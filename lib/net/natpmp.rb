# frozen_string_literal: true

# ENV['HOME'] ||= ENV['HOMEPATH'] ? "#{ENV['HOMEDRIVE']}#{ENV['HOMEPATH']}" : Dir.pwd

require_relative 'natpmp/config'
require_relative 'natpmp/client'
require_relative 'natpmp/errors'
require_relative 'natpmp/requests'
require_relative 'natpmp/responses'

module Net
  # Main class
  module NATPMP
    # Instantiate class with default params.
    # Takes a config instance or any other params.
    # :gw is mandatory if config instance not provided
    def self.client(config)
      return Client.new(config) if config.is_a?(Config)

      unless config[:gw]
        raise Net::NATPMP::Exception,
              'Gateway is missing. Call with: Net::NATPMP.client(gw: "x.x.x.x")'
      end

      Client.new(Config.new(**config))
    end
  end
end
