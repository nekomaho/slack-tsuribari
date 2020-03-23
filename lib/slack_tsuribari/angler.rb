# frozen_string_literal: true

require 'slack_tsuribari/connection'

module SlackTsuribari
  module Angler
    class << self
      def easy_throw!(hook, message, auto_detach = true)
        payload = { text: message }
        throw_action(hook, payload, auto_detach)
      end

      def throw!(hook, payload = nil, auto_detach = true)
        throw_action(hook, payload, auto_detach)
      end

      private

      def throw_action(hook, payload, auto_detach)
        hook.attach(payload) unless payload.nil?
        Connection.new(hook.uri, hook.proxy_setting).post(hook.payload_to_json).tap do
          hook.detach if auto_detach
        end
      end
    end
  end
end
