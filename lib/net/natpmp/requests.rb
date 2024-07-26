# frozen_string_literal: true

require 'socket'
require 'ipaddr'

module Net
  module NATPMP
    # Main request class
    class Request
      include Constants

      attr_reader :socket, :config

      def initialize(config)
        @config = config

        @socket = UDPSocket.new
        @socket.bind(config.bind_address.to_s, config.bind_port)
        @socket.connect(config.gw.to_s, config.port)
      end

      def self.req(config, _opts = {})
        new(config)
      end

      # Send a message to the NAT-PMP server. Takes a message and an optional response size
      def send(msg, expected_response_size = 16)
        sent_op = msg.unpack1('xC') # To verify the response
        size_sent = @socket.send(msg, 0)

        raise RequestFailed unless size_sent == msg.size

        delay = Constants::BASE_DELAY
        attempts = 1

        begin
          sleep delay
          reply, = @socket.recvfrom_nonblock(expected_response_size)

          check_reply(reply, sent_op)

          reply
        rescue IO::WaitReadable
          if delay < MAX_WAIT
            delay *= 2
            puts "Timeout, retrying after #{delay} seconds"
            attempts += 1
            retry
          end

          raise TimeoutException, "Timeout after #{attempts} attempts"
        rescue Errno::ECONNREFUSED
          raise ConnectionRefused, 'Connection refused'
        end
      ensure
        sleep 0.25 # Sleep for a bit to make sure the socket is not closed too soon
        @socket.close # Close the socket because we don't need it anymore
      end

      def check_reply(reply, sent_op)
        # Check the first 4 bytes only (the rest are variable)
        version, opcode, result = reply.unpack('CCn')

        # Check the version in the reply
        raise InvalidVersion, "Invalid version #{version}" unless version == VERSION

        # Check the operation code in the reply. Always (128 + sent opcode)
        expected_opcode = 128 + sent_op
        if opcode != expected_opcode
          raise InvalidReply,
                "Invalid reply opcode. Was expecting #{expected_opcode}, got: #{opcode}"
        end

        # Check the result code in the reply
        raise RequestFailed, result_code: result unless result == RESULT_CODES[:success]
      end
    end

    # Request class specific to External address
    class ExternalAddressRequest < Request
      def self.req(config)
        instance = super(config)
        msg = [VERSION, OP_CODES[:address]].pack('CC')

        ExternalAddressResponse.new(instance.send(msg, 12))
      end
    end

    # Represents a port mapping request
    class MappingRequest < Request
      def self.req(config, proto:, inside_port:, outside_port:, lifetime:)
        # TODO: Ensure proto is either :udp or :tcp

        instance = super(config)
        msg = [
          VERSION, OP_CODES[PROTO_CODES[proto]], 0,
          inside_port, outside_port,
          lifetime
        ].pack('CCnnnN')

        MappingResponse.new(instance.send(msg, 16), proto: proto)
      end
    end
  end
end
