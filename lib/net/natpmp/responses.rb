# frozen_string_literal: true

module Net
  module NATPMP
    # Response class
    class Response
      attr_reader :raw_response

      def initialize(response, _ = {})
        @raw_response = response
      end
    end

    # Response for the external address request
    class ExternalAddressResponse < Response
      attr_reader :ip_int

      def initialize(response)
        super
        @ip_int = response.unpack1('@8N')
      end

      def address
        IPAddr.new(ip_int, Socket::AF_INET)
      end

      def to_s
        address.to_s
      end

      def inspect
        "External address: #{address}"
      end
    end

    # Response for the mapping request
    class MappingResponse < Response
      attr_reader :inside_port, :outside_port, :lifetime, :proto

      def initialize(response, proto:)
        super

        @proto = proto
        @inside_port, @outside_port, @lifetime = response.unpack('@8nnN')
      end

      def inspect
        "Port mapping: #{@outside_port} -> #{@proto}:#{@inside_port} (lifetime: #{@lifetime})"
      end
    end
  end
end
