module Net
  module NATPMP
    class Response
      attr_reader :version, :opcode, :result, :sec_since_epoch, :ip_int, :internal_port, :external_port, :lifetime

      def initialize(response); end
    end

    class ExternalAddressResponse < Response
      def initialize(response)
        super
        @version, @opcode, @result, @sec_since_epoch, @ip_int = response.unpack('CCSNN')
      end

      def ip
        IPAddr.new(ip_int, Socket::AF_INET)
      end
    end

    class MappingResponse < Response
      def initialize(response)
        super(response)

        @version,
        @opcode,
        @result,
        @sec_since_epoch,
        @internal_port,
        @external_port,
        @lifetime = response.unpack('CCSNnnN')
      end
    end
  end
end
