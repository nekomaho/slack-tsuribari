# frozen_string_literal: true

require 'slack_tsuribari/connection'

module SlackTsuribari
  module Angler
    class << self
      def throw!(hook, payload = nil, auto_detach = true)
        hook.attach(payload) unless payload.nil?
        Connection.new(hook.uri).post(hook.payload_to_json).tap do
          hook.detach if auto_detach
        end
      end
    end
  end
end
