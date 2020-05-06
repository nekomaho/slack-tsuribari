# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SlackTsuribari::Connection do
  describe '#initialize' do
    context 'no options' do
      subject { described_class.new('https://test.co.jp:49990/test') }

      it 'is initialize attributes' do
        subject.tap do |conn|
          expect(conn.scheme).to eq 'https'
          expect(conn.host).to eq 'test.co.jp'
          expect(conn.port).to eq 49_990
          expect(conn.path).to eq '/test'
          expect(conn.proxy_addr).to eq :ENV
          expect(conn.proxy_port).to be_nil
          expect(conn.proxy_user).to be_nil
          expect(conn.proxy_pass).to be_nil
          expect(conn.no_proxy).to be_nil
        end
      end
    end

    context 'with options' do
      subject do
        described_class.new(
          'https://test.co.jp:49990/test',
          proxy_addr: '127.0.0.1',
          proxy_port: 80,
          proxy_user: 'user',
          proxy_pass: 'password',
          no_proxy: '192.168.0.1'
        )
      end

      it "is initialized attributes that include proxy's values" do
        subject.tap do |conn|
          expect(conn.scheme).to eq 'https'
          expect(conn.host).to eq 'test.co.jp'
          expect(conn.port).to eq 49_990
          expect(conn.path).to eq '/test'
          expect(conn.proxy_addr).to eq '127.0.0.1'
          expect(conn.proxy_port).to eq 80
          expect(conn.proxy_user).to eq 'user'
          expect(conn.proxy_pass).to eq 'password'
          expect(conn.no_proxy).to eq '192.168.0.1'
        end
      end
    end
  end

  describe '#post' do
    context 'check value at post' do
      subject { described_class.new('https://test.co.jp/test').post('{test: 1}') }

      before do
        allow_any_instance_of(Net::HTTP).to receive(:post) do |_, path, data, header|
          @result = [path, data, header]
          Net::HTTPOK.new('1.1', 200, 'OK')
        end
      end

      it 'receive correct path, date and header' do
        subject
        expect(@result).to eq ['/test', '{test: 1}', 'Content-Type' => 'application/json']
      end
    end

    context 'response case' do
      context 'when raise_error option is true' do
        subject { described_class.new('https://test.co.jp/test').post('{test: 1}') }

        context 'when return 2xx' do
          let(:response) do
            Net::HTTPOK.new('1.1', '200', 'OK')
          end

          before do
            allow_any_instance_of(Net::HTTP).to receive(:post).and_return(response)
          end

          it { is_expected.to eq response }
        end

        context 'when return other than 2xx' do
          let(:response) do
            Net::HTTPForbidden.new('1.1', '403', 'Forbidden')
          end
          let(:raise_response) do
            RUBY_VERSION < '2.6.0' ? Net::HTTPServerException : Net::HTTPClientException
          end

          before do
            allow_any_instance_of(Net::HTTP).to receive(:post).and_return(response)
          end

          it { expect { subject }.to raise_error(raise_response) }
        end
      end

      context 'when raise_error option is false' do
        subject { described_class.new('https://test.co.jp/test', { raise_error: false }).post('{test: 1}') }

        context 'when return 2xx' do
          let(:response) do
            Net::HTTPOK.new('1.1', '200', 'OK')
          end

          before do
            allow_any_instance_of(Net::HTTP).to receive(:post).and_return(response)
          end

          it { is_expected.to eq response }
        end

        context 'when return other than 2xx' do
          let(:response) do
            Net::HTTPForbidden.new('1.1', '403', 'Forbidden')
          end

          before do
            allow_any_instance_of(Net::HTTP).to receive(:post).and_return(response)
          end

          it { is_expected.to eq response }
        end
      end
    end
  end
end
