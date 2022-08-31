# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Configurable do
  describe 'README' do
    describe 'Configured with' do
      before do
        MyConfigurable.configure(port: 5555) do |config|
          config.host 'interstella.art'
        end
      end

      after do
        MyConfigurable.reset_config
      end

      it 'sets configuration host' do
        expect(MyConfigurable.config.host)
          .to eq('interstella.art')
      end

      it 'sets configuration port' do
        expect(MyConfigurable.config.port)
          .to eq(5555)
      end

      it 'enables options to be returned' do
        expect(MyConfigurable.as_options.host)
          .to eq('interstella.art')
      end

      it 'enables options to be returned' do
        expect(MyConfigurable.as_options(host: 'other').host)
          .to eq('other')
      end


      context 'when #reset_config is called' do
        before do
          MyConfigurable.reset_config
        end

        it 'resets configuration host' do
          expect(MyConfigurable.config.host)
            .to be_nil
        end

        it 'resets configuration port' do
          expect(MyConfigurable.config.port).to eq(80)
        end
      end
    end

    describe 'Configured by' do
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
