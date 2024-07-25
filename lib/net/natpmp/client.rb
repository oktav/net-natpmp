# frozen_string_literal: true

module Net
  module NATPMP
    # Client class
    class Client
      attr_reader :config

      def initialize(config)
        @config = config
      end

      # Replies with the external address of the gateway
      def external_address
        ExternalAddressRequest.req(@config)
      end

      def map_port(proto: :udp)
        MappingRequest.req(@config, proto: proto)
      end
    end
  end
end
