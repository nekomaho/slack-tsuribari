# frozen_string_literal: true

require 'json'

module SlackTsuribari
  class Hook
    class << self
      def config(uri = nil)
        config = {}

        if block_given?
          yield(config)
        else
          config[:uri] = uri
        end
        new(config)
      end
    end

    attr_reader :config, :payload

    def initialize(config)
      @config = config
    end

    def uri
      @config[:uri]
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