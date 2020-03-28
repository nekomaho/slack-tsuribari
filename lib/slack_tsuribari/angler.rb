# frozen_string_literal: true

require 'slack_tsuribari/connection'

module SlackTsuribari
  module Angler
    class << self
      def easy_throw!(hook, message = nil)
        payload = message.nil? ? nil : { text: message }
        throw_action(hook, payload, true)
      end

      def throw!(hook, payload = nil)
        throw_action(hook, payload, true)
      end

      private

      def throw_action(hook, payload, auto_detach)
        hook.attach(payload)
        Connection.new(hook.uri, hook.proxy_setting).post(hook.payload_to_json).tap do
          hook.detach if auto_detach
        end
      end
    end
  end
end
