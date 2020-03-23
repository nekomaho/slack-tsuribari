# frozen_string_literal: true

require 'json'

module SlackTsuribari
  class Hook
    Config = Struct.new(:uri, :proxy_addr, :proxy_port, :proxy_user, :proxy_pass, :no_proxy)

    class << self
      def config(uri = nil)
        config = Config.new

        if block_given?
          yield(config)
        else
          config.uri = uri
        end
        new(config)
      end
    end

    attr_reader :config, :payload

    def initialize(config)
      @config = config
    end

    def uri
      config.uri
    end

    def proxy_setting
      {
        proxy_addr: config.proxy_addr,
        proxy_port: config.proxy_port,
        proxy_user: config.proxy_user,
        proxy_pass: config.proxy_pass,
        no_proxy: config.no_proxy
      }
    end

    def payload_to_json
      payload.to_json
    end

    def attach(payload)
      @payload = payload
    end

    def detach
      @payload = nil
    end
  end
end
