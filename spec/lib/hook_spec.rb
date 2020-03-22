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
