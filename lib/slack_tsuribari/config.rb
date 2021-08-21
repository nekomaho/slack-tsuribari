# frozen_string_literal: true

module SlackTsuribari
  def self.configure
    @_config = yield(Config.new)
  end

  def self.connection_config(name)
    @_config.connections.index do |connection|
      name == connection.name
    end
  end

  class Config
    PrePayload = Struct.new(:channel, :username, :text, :icon_url, :icon_emoji) do
      def to_h
        %I[channel username text icon_url icon_emoji].each_with_object({}) do |attr, hash|
          hash[attr] = send(attr) unless send(attr).nil?
        end
      end

      def nil?
        %I[channel username text icon_url icon_emoji].all? { |attr| send(attr).nil? }
      end
    end

    ConfigValue = Struct.new(
      :name,
      :uri,
      :proxy_addr,
      :proxy_port,
      :proxy_user,
      :proxy_pass,
      :no_proxy,
      :pre_payload,
      :raise_error,
      keyword_init: true
    )

    attr_reader :connections

    def initialize
      @connections = []
    end

    def connection(name)
      if block_given?
        @connections << {name: name, config: yield(Config.new(pre_payload: PrePayload.new, raise_error: true))}
      else
        raise 'Need config setting block'
      end
    end
  end
end
