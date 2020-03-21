# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe SlackTsuribari::Angler do
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
  end
end
