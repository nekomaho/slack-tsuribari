# frozen_string_literal: true

require 'net/http'

module SlackTsuribari
  class Connection
    attr_reader :scheme, :host, :port, :path
    attr_reader :proxy_addr, :proxy_port, :proxy_user, :proxy_pass, :no_proxy

    def initialize(uri, options = {})
      URI.parse(uri).tap do |parse_uri|
        @scheme = parse_uri.scheme
        @host = parse_uri.host
        @path = parse_uri.path
        @port = parse_uri.port
      end
      @proxy_addr = options[:proxy_addr] || :ENV
      @proxy_port = options[:proxy_port] || nil
      @proxy_user = options[:proxy_user] || nil
      @proxy_pass = options[:proxy_pass] || nil
      @no_proxy = options[:no_proxy] || nil
    end

    def post(data, header = { 'Content-Type' => 'application/json' })
      Net::HTTP.new(host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy).yield_self do |http|
        http.use_ssl = scheme == 'https'
        http.post(path, data, header)
      end
    end
  end
end
