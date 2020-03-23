# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe SlackTsuribari::Hook do
  describe '.config' do
    context 'with block' do
      subject do
        described_class.config do |config|
          config[:uri] = 'https://test.co.jp/'
        end.config
      end

      let(:result) do
        {
          uri: 'https://test.co.jp/'
        }
      end

      it { is_expected.to eq result }
    end

    context 'with no block' do
      subject { described_class.config('https://test.co.jp/').config }

      let(:result) do
        {
          uri: 'https://test.co.jp/'
        }
      end

      it { is_expected.to eq result }
    end
  end

  describe '#uri' do
    subject { described_class.new({ uri: 'https://test.co.jp/' }).uri }

    it { is_expected.to eq 'https://test.co.jp/' }
  end

  describe '#proxy_setting' do
    subject do
      described_class.config do |config|
        config[:uri] = 'https://test.co.jp/'
        config[:proxy_addr] = '127.0.0.1'
        config[:proxy_port] = 8080
        config[:proxy_user] = 'test'
        config[:proxy_pass] = 'password'
        config[:no_proxy] = '192.168.1.1'
      end.proxy_setting
    end

    let(:result) do
      {
        proxy_addr: '127.0.0.1',
        proxy_port: 8080,
        proxy_user: 'test',
        proxy_pass: 'password',
        no_proxy: '192.168.1.1'
      }
    end

    it { is_expected.to eq result }
  end

  describe '#payload_to_json' do
    subject do
      described_class.new({ uri: 'https://test.co.jp/' }).yield_self do |hook|
        hook.attach({ text: 'test' })
        hook.payload_to_json
      end
    end

    it { is_expected.to eq({ text: 'test' }.to_json) }
  end

  describe '#attach' do
    subject do
      described_class.new({ uri: 'https://test.co.jp/' }).yield_self do |hook|
        hook.attach({ text: 'test' })
        hook.payload
      end
    end

    it { is_expected.to eq({ text: 'test' }) }
  end

  describe '#detach' do
    subject do
      described_class.new({ uri: 'https://test.co.jp/' }).yield_self do |hook|
        hook.attach({ text: 'test' })
        hook.detach
        hook.payload
      end
    end

    it { is_expected.to be_nil }
  end
end
