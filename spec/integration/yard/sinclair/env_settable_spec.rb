# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  describe '#yard' do
    subject(:settable) { Class.new(MyAppClient) }

    before do
      ENV['MY_APP_USERNAME'] = 'my_login'
    end

    after do
      ENV.delete('MY_APP_USERNAME')
    end

    it 'retrieves username from env' do
      expect(settable.username).to eq('my_login')
    end

    it 'retrieves password from env' do
      expect(settable.password).to be_nil
    end

    context 'when defining defaults' do
      it 'returns default value' do
        expect(settable.host).to eq('my-host.com')
      end

      context 'when setting the env variable' do
        before do
          ENV['MY_APP_HOST'] = 'other-host.com'
        end

        after do
          ENV.delete('MY_APP_HOST')
        end

        it 'retrieves host from env' do
          expect(settable.host).to eq('other-host.com')
        end
      end
    end
  end
end
