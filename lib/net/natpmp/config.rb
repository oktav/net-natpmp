# frozen_string_literal: true

module Net
  module NATPMP
    # Provides all necessary configuration with some defaults
    class Config
      NATPMP_PORT = 5351
      BIND_ADDRESS = '0.0.0.0'
      BIND_PORT = 5350

      attr_reader :bind_address, :bind_port, :gw, :port

      def initialize(
        gw:,
        port: NATPMP_PORT,
        bind_address: BIND_ADDRESS,
        bind_port: BIND_PORT
      )

        @bind_address = IPAddr.new(bind_address)
        @bind_port = bind_port
        @gw = IPAddr.new(gw)
        @port = port
      rescue IPAddr::InvalidAddressError
        raise InvalidParameter, 'Value must be a valid IP Address'
      end
    end
  end
end
