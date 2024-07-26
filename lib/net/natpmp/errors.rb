# frozen_string_literal: true

module Net
  module NATPMP
    # General exception
    class Exception < ::RuntimeError; end

    class InvalidParameter < Exception; end

    # Timeout exception
    class TimeoutException < Exception
      def initialize(msg = 'Request timed out')
        super
      end
    end

    class InvalidVersion < Exception; end

    class InvalidReply < Exception; end

    # Exception should be thrown when the request fails
    class RequestFailed < Exception
      include Constants

      def initialize(opts = {})
        msg = opts[:msg] || 'Failed to send the request'

        if (@result_code = opts[:result_code])
          msg = "#{msg}. Server replied: #{RESULT_CODES_DESC[@result_code]}(#{@result_code})"
        end

        super(msg)
      end
    end

    class ConnectionRefused < Exception; end
  end
end
