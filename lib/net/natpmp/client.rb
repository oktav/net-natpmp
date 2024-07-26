# frozen_string_literal: true

module Net
  module NATPMP
    # Client class
    class Client
      include Constants

      attr_reader :config

      def initialize(config)
        @config = config
      end

      # Replies with the external address of the gateway
      def external_address
        ExternalAddressRequest.req(@config)
      end

      # Maps a port on the gateway
      def map_port(
        proto: DEFAULT_PROTO,
        inside_port: DEFAULT_INSIDE_PORT,
        outside_port: DEFAULT_OUTSIDE_PORT,
        lifetime: DEFAULT_LIFETIME
      )
        MappingRequest.req(
          @config,
          proto: proto,
          inside_port: inside_port,
          outside_port: outside_port,
          lifetime: lifetime
        )
      end

      # Destroys a port mapping on the gateway
      def destroy_mapping(port: 0, proto: DEFAULT_PROTO)
        MappingRequest.req(@config, proto: proto, inside_port: port, outside_port: 0, lifetime: 0)
      end
    end
  end
end
