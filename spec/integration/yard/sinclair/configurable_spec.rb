# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Configurable do
  describe '#yard' do
    describe '#configurable_with' do
      before do
        MyConfigurable.configure do
          host 'interstella.com'
          port 5555
        end
      end

      after do
        MyConfigurable.reset_config
      end

      it 'sets right value for config host' do
        expect(MyConfigurable.config.host)
          .to eq('interstella.com')
      end

      it 'sets right value for config port' do
        expect(MyConfigurable.config.port)
          .to eq(5555)
      end

      context 'when reset_config is called' do
        before { MyConfigurable.reset_config }

        it 'returns initial value for host' do
          expect(MyConfigurable.config.host).to be_nil
        end

        it 'returns initial value for port' do
          expect(MyConfigurable.config.port).to eq(80)
        end
      end
    end

    describe '#configurable_by' do
      before do
        Client.configure do
          host 'interstella.com'
        end
      end

      after do
        Client.reset_config
      end

      it 'sets host' do
        expect(Client.config.url)
          .to eq('http://interstella.com')
      end

      context 'when setting the port' do
        before do
          Client.configure do |config|
            config.port 8080
          end
        end

        it 'sets host and port' do
          expect(Client.config.url)
            .to eq('http://interstella.com:8080')
        end
      end
    end
  end
end
