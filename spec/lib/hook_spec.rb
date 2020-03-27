# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe SlackTsuribari::Hook do
  describe SlackTsuribari::Hook::PrePayload do
    describe '#to_h' do
      context 'all attributes is nil' do
        subject { described_class.new.to_h }

        let(:result) { {} }

        it { is_expected.to eq result }
      end

      context 'when icon_url exists' do
        subject do
          described_class.new.tap do |pre_payload|
            pre_payload.channel = 'test'
            pre_payload.username = 'test'
            pre_payload.text = 'test'
            pre_payload.icon_url = 'http://test'
          end.to_h
        end

        let(:result) do
          {
            channel: 'test',
            username: 'test',
            text: 'test',
            icon_url: 'http://test'
          }
        end

        it { is_expected.to eq result }
      end

      context 'when icon_emoji attribute exists' do
        subject do
          described_class.new.tap do |pre_payload|
            pre_payload.channel = 'test'
            pre_payload.username = 'test'
            pre_payload.text = 'test'
            pre_payload.icon_emoji = ':test:'
          end.to_h
        end

        let(:result) do
          {
            channel: 'test',
            username: 'test',
            text: 'test',
            icon_emoji: ':test:'
          }
        end

        it { is_expected.to eq result }
      end
    end
  end

  describe '.config' do
    context 'with block' do
      subject do
        described_class.config do |config|
          config.uri = 'https://test.co.jp/'
        end.config
      end

      let(:result) do
        SlackTsuribari::Hook::Config.new(
          uri: 'https://test.co.jp/',
          pre_payload: SlackTsuribari::Hook::PrePayload.new
        )
      end

      it { is_expected.to eq result }
    end

    context 'with no block' do
      subject { described_class.config('https://test.co.jp/').config }

      let(:result) do
        SlackTsuribari::Hook::Config.new(
          uri: 'https://test.co.jp/',
          pre_payload: SlackTsuribari::Hook::PrePayload.new
        )
      end

      it { is_expected.to eq result }
    end

    context 'with block and pre_payload setting' do
      subject do
        described_class.config do |config|
          config.uri = 'https://test.co.jp/'
          config.pre_payload.channel = 'test'
          config.pre_payload.username = 'test'
        end.config
      end

      let(:result) do
        SlackTsuribari::Hook::Config.new(
          uri: 'https://test.co.jp/',
          pre_payload: SlackTsuribari::Hook::PrePayload.new('test', 'test')
        )
      end

      it { is_expected.to eq result }
    end
  end

  describe '#uri' do
    subject { described_class.config('https://test.co.jp/').uri }

    it { is_expected.to eq 'https://test.co.jp/' }
  end

  describe '#proxy_setting' do
    subject do
      described_class.config do |config|
        config.uri = 'https://test.co.jp/'
        config.proxy_addr = '127.0.0.1'
        config.proxy_port = 8080
        config.proxy_user = 'test'
        config.proxy_pass = 'password'
        config.no_proxy = '192.168.1.1'
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
      described_class.config('https://test.co.jp/').yield_self do |hook|
        hook.attach({ text: 'test' })
        hook.payload_to_json
      end
    end

    it { is_expected.to eq({ text: 'test' }.to_json) }
  end

  describe '#attach' do
    context 'no pre_payload setting' do
      subject do
        described_class.config('https://test.co.jp/').yield_self do |hook|
          hook.attach({ text: 'test' })
          hook.payload
        end
      end

      it { is_expected.to eq({ text: 'test' }) }
    end

    context 'pre_payload setting without text attribute' do
      subject do
        hook = described_class.config('https://test.co.jp/') do |config|
          config.pre_payload.channel = 'test'
        end
        hook.attach({ text: 'test' })
        hook.payload
      end

      it { is_expected.to eq({ channel: 'test', text: 'test' }) }
    end

    context 'pre_payload setting with text attribute' do
      subject do
        hook = described_class.config('https://test.co.jp/') do |config|
          config.pre_payload.text = 'pre test'
        end
        hook.attach({ text: 'test' })
        hook.payload
      end

      it { is_expected.to eq({ text: 'test' }) }
    end
  end

  describe '#detach' do
    subject do
      described_class.config('https://test.co.jp/').yield_self do |hook|
        hook.attach({ text: 'test' })
        hook.detach
        hook.payload
      end
    end

    it { is_expected.to be_nil }
  end
end
