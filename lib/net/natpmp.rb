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
    # Instantiate class with default params
    # bind address, bind port, remote gw, remote port
    def self.client(params)
      return Client.new(params) if params.is_a?(Config)

      raise Net::NATPMP::Exception, 'required param :gw' unless params[:gw]

      config_params = {
        bind_address: params[:bind_address] || Config::BIND_ADDRESS,
        bind_port: params[:bind_port] || Config::BIND_PORT,
        port: params[:port] || Config::NATPMP_PORT,
        gw: params[:gw]
      }

      Client.new(Config.new(**config_params))
    end
  end
end
