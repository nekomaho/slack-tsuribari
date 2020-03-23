# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe SlackTsuribari::Angler do
  describe '.easy_throw!' do
    context 'auto_detach is true' do
      subject { described_class.easy_throw!(hook, 'something') }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'auto_detach is false' do
      subject { described_class.easy_throw!(hook, 'something', false) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { { text: 'something' } }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to eq payload
      end
    end

    context 'proxy is specified' do
      subject { described_class.easy_throw!(hook, 'something') }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config[:uri] = 'https://test.co.jp/hook'
          config[:proxy_addr] = '127.0.0.1'
          config[:proxy_port] = 8080
          config[:proxy_user] = 'test'
          config[:proxy_pass] = 'password'
          config[:no_proxy] = '192.168.1.1'
        end
      end
      let(:payload) { { text: 'something' } }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy|
          @host_port_result = [host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443, '127.0.0.1', 8080, 'test', 'password', '192.168.1.1']
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end
  end

  describe '.throw!' do
    context 'payload is nil' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { nil }
      let(:payload_result) { 'null' }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'payload is contain' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { { text: 'test' } }
      let(:payload_result) { JSON.dump({ text: 'test' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'auto_detach is false' do
      subject { described_class.throw!(hook, payload, false) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { { text: 'test' } }
      let(:payload_result) { JSON.dump({ text: 'test' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to eq payload
      end
    end

    context 'proxy is specified' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config[:uri] = 'https://test.co.jp/hook'
          config[:proxy_addr] = '127.0.0.1'
          config[:proxy_port] = 8080
          config[:proxy_user] = 'test'
          config[:proxy_pass] = 'password'
          config[:no_proxy] = '192.168.1.1'
        end
      end
      let(:payload) { { text: 'something' } }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy|
          @host_port_result = [host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443, '127.0.0.1', 8080, 'test', 'password', '192.168.1.1']
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end
  end
end
