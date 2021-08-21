# frozen_string_literal: true

module SlackTsuribari
  def self.post(name: :default, message:)
    Sender.new(connection_config(name), message).send_message
  end

  class Sender
    attr_reader :config

    def initialize(config, message)
      @config = config
      @message = message
    end

    def send_message
      Connection.new(config.uri, setting).post(message_to_json)
    end

    private

    def setting
      {
        proxy_addr: config.proxy_addr,
        proxy_port: config.proxy_port,
        proxy_user: config.proxy_user,
        proxy_pass: config.proxy_pass,
        no_proxy: config.no_proxy,
        raise_error: config.raise_error
      }
    end

    def message_to_json
      message.to_json
    end
  end
end
