# frozen_string_literal: true

require 'json'

module SlackTsuribari
  class Hook
    PrePayload = Struct.new(:channel, :username, :text, :icon_url, :icon_emoji) do
      def to_h
        %I[channel username text icon_url icon_emoji].each_with_object({}) do |attr, hash|
          hash[attr] = send(attr) unless send(attr).nil?
        end
      end
    end

    Config = Struct.new(
      :uri,
      :proxy_addr,
      :proxy_port,
      :proxy_user,
      :proxy_pass,
      :no_proxy,
      :pre_payload,
      keyword_init: true
    )

    class << self
      def config(uri = nil)
        config = Config.new(pre_payload: PrePayload.new)

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
      @payload = config.pre_payload.to_h.merge(payload)
    end

    def detach
      @payload = nil
    end
  end
end
