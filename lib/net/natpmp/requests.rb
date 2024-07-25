# frozen_string_literal: true

require 'socket'
require 'ipaddr'

module Net
  module NATPMP
    VERSION = 0

    PROTO_CODES = {
      udp: :map_udp,
      tcp: :map_tcp
    }.freeze

    OP_CODES = {
      address: 0,
      map_udp: 1,
      map_tcp: 2
    }.freeze

    # Main request class
    class Request
      attr_reader :socket, :config

      def initialize(config)
        @config = config

        @socket = UDPSocket.new
        @socket.bind(config.bind_address, config.bind_port)
      end

      def self.req(config, _opts = {})
        new(config)
      end

      def send(msg)
        @socket.send msg, 0, @config.gw, @config.port
      end
    end

    # Request class specific to External address
    class ExternalAddressRequest < Request
      def self.req(config)
        instance = super(config)
        instance.send([VERSION, OP_CODES[:address]].pack('CC'))
        ExternalAddressResponse.new(instance.socket.recv(12))
      end
    end

    class MappingRequest < Request
      def self.req(config, proto: :udp, in_port: 0, out_port: 1, lifetime: 60)
        # TODO: Ensure proto is either :udp or :tcp

        instance = super(config)
        msg = [
          VERSION,
          OP_CODES[PROTO_CODES[proto]],
          0,
          in_port,
          out_port,
          lifetime
        ].pack('CCnnnN')

        instance.send(msg)

        MappingResponse.new(instance.socket.recv(16))
      end
    end
  end
end
