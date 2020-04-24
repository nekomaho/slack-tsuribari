# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe SlackTsuribari::Angler do
  describe '.easy_throw!' do
    context 'with message' do
      subject { described_class.easy_throw!(hook, 'something') }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'pre payload is specified' do
      subject { described_class.easy_throw!(hook, 'something') }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.pre_payload.channel = 'test'
          config.pre_payload.username = 'name'
          config.pre_payload.icon_emoji = ':+1:'
        end
      end
      let(:payload_result) { JSON.dump({ channel: 'test', username: 'name', icon_emoji: ':+1:', text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'message is nil and pre payload is not specified' do
      subject { described_class.easy_throw!(hook) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { nil }
      let(:payload_result) { 'null' }

      it 'raise NoPayloadError' do
        expect { subject }.to raise_error(SlackTsuribari::Hook::NoPayloadError)
      end
    end

    context 'message is nil and pre payload text is specified' do
      subject { described_class.easy_throw!(hook) }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.pre_payload.text = 'text'
        end
      end
      let(:payload_result) { JSON.dump({ text: 'text' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'proxy is specified' do
      subject { described_class.easy_throw!(hook, 'something') }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.proxy_addr = '127.0.0.1'
          config.proxy_port = 8080
          config.proxy_user = 'test'
          config.proxy_pass = 'password'
          config.no_proxy = '192.168.1.1'
        end
      end
      let(:payload) { { text: 'something' } }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy|
          @host_port_result = [host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443, '127.0.0.1', 8080, 'test', 'password', '192.168.1.1']
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'raise_error is specified' do
      context 'when raise error true (default)' do
        subject { described_class.easy_throw!(hook, 'something') }

        let(:hook) do
          SlackTsuribari::Hook.config('https://test.co.jp/hook')
        end
        let(:payload) { { text: 'something' } }
        let(:payload_result) { JSON.dump({ text: 'something' }) }
        let(:net_http_double) { instance_double(Net::HTTP) }
        let(:response) { Net::HTTPForbidden.new('1.1', '403', 'Forbidden') }

        before do
          allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _|
            @host_port_result = [host, port]
            net_http_double
          end
          allow(net_http_double).to receive(:use_ssl=)
          allow(net_http_double).to receive(:post) do |path, data, _|
            @path_data_result = [path, data]
            response
          end
        end

        it 'host, port and data is correct and return 403 with raise error' do
          expect { subject }.to raise_error(Net::HTTPClientException)
          expect(@host_port_result).to eq ['test.co.jp', 443]
          expect(@path_data_result).to eq ['/hook', payload_result]
          expect(hook.payload).to be_nil
        end
      end

      context 'when raise error false' do
        subject { described_class.easy_throw!(hook, 'something') }

        let(:hook) do
          SlackTsuribari::Hook.config do |config|
            config.uri = 'https://test.co.jp/hook'
            config.raise_error = false
          end
        end
        let(:payload) { { text: 'something' } }
        let(:payload_result) { JSON.dump({ text: 'something' }) }
        let(:net_http_double) { instance_double(Net::HTTP) }
        let(:response) { Net::HTTPForbidden.new('1.1', '403', 'Forbidden') }

        before do
          allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _|
            @host_port_result = [host, port]
            net_http_double
          end
          allow(net_http_double).to receive(:use_ssl=)
          allow(net_http_double).to receive(:post) do |path, data, _|
            @path_data_result = [path, data]
            response
          end
        end

        it 'host, port and data is correct and return 403 without raise error' do
          is_expected.to eq response
          expect(@host_port_result).to eq ['test.co.jp', 443]
          expect(@path_data_result).to eq ['/hook', payload_result]
          expect(hook.payload).to be_nil
        end
      end
    end
  end

  describe '.throw!' do
    context 'pre payload is specified' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.pre_payload.channel = 'test'
          config.pre_payload.username = 'name'
          config.pre_payload.icon_emoji = ':+1:'
        end
      end
      let(:payload) { { text: 'test' } }
      let(:payload_result) { JSON.dump({ channel: 'test', username: 'name', icon_emoji: ':+1:', text: 'test' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'payload is nil and pre payload text is not specified' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
      let(:payload) { nil }
      let(:payload_result) { 'null' }

      it 'raise NoPayloadError' do
        expect { subject }.to raise_error(SlackTsuribari::Hook::NoPayloadError)
      end
    end

    context 'payload is nil and pre payload text is specified' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.pre_payload.text = 'pre payload text'
        end
      end
      let(:payload) { nil }
      let(:payload_result) { JSON.dump({ text: 'pre payload text' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
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
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _, _|
          @host_port_result = [host, port]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443]
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'proxy is specified' do
      subject { described_class.throw!(hook, payload) }

      let(:hook) do
        SlackTsuribari::Hook.config do |config|
          config.uri = 'https://test.co.jp/hook'
          config.proxy_addr = '127.0.0.1'
          config.proxy_port = 8080
          config.proxy_user = 'test'
          config.proxy_pass = 'password'
          config.no_proxy = '192.168.1.1'
        end
      end
      let(:payload) { { text: 'something' } }
      let(:payload_result) { JSON.dump({ text: 'something' }) }
      let(:net_http_double) { instance_double(Net::HTTP) }
      let(:response) { Net::HTTPOK.new('1.1', '200', 'OK') }

      before do
        allow(Net::HTTP).to receive(:new) do |host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy|
          @host_port_result = [host, port, proxy_addr, proxy_port, proxy_user, proxy_pass, no_proxy]
          net_http_double
        end
        allow(net_http_double).to receive(:use_ssl=)
        allow(net_http_double).to receive(:post) do |path, data, _|
          @path_data_result = [path, data]
          response
        end
      end

      it 'host, port and data is correct' do
        subject
        expect(@host_port_result).to eq ['test.co.jp', 443, '127.0.0.1', 8080, 'test', 'password', '192.168.1.1']
        expect(@path_data_result).to eq ['/hook', payload_result]
        expect(hook.payload).to be_nil
      end
    end

    context 'raise_error is specified' do
      context 'when raise error true (default)' do
        subject { described_class.throw!(hook, payload) }

        let(:hook) { SlackTsuribari::Hook.config('https://test.co.jp/hook') }
        let(:payload) { { text: 'test' } }
        let(:payload_result) { JSON.dump({ text: 'test' }) }
        let(:net_http_double) { instance_double(Net::HTTP) }
        let(:response) { Net::HTTPForbidden.new('1.1', '403', 'Forbidden') }

        before do
          allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _|
            @host_port_result = [host, port]
            net_http_double
          end
          allow(net_http_double).to receive(:use_ssl=)
          allow(net_http_double).to receive(:post) do |path, data, _|
            @path_data_result = [path, data]
            response
          end
        end

        it 'host, port and data is correct and return 403 with raise error' do
          expect { subject }.to raise_error(Net::HTTPClientException)
          expect(@host_port_result).to eq ['test.co.jp', 443]
          expect(@path_data_result).to eq ['/hook', payload_result]
          expect(hook.payload).to be_nil
        end
      end

      context 'when raise error false' do
        subject { described_class.throw!(hook, payload) }
        let(:hook) do
          SlackTsuribari::Hook.config do |config|
            config.uri = 'https://test.co.jp/hook'
            config.raise_error = false
          end
        end
        let(:payload) { { text: 'test' } }
        let(:payload_result) { JSON.dump({ text: 'test' }) }
        let(:net_http_double) { instance_double(Net::HTTP) }
        let(:response) { Net::HTTPForbidden.new('1.1', '403', 'Forbidden') }

        before do
          allow(Net::HTTP).to receive(:new) do |host, port, _, _, _, _, _|
            @host_port_result = [host, port]
            net_http_double
          end
          allow(net_http_double).to receive(:use_ssl=)
          allow(net_http_double).to receive(:post) do |path, data, _|
            @path_data_result = [path, data]
            response
          end
        end

        it 'host, port and data is correct and return 403 without raise error' do
          is_expected.to eq response
          expect(@host_port_result).to eq ['test.co.jp', 443]
          expect(@path_data_result).to eq ['/hook', payload_result]
          expect(hook.payload).to be_nil
        end
      end
    end
  end
end
