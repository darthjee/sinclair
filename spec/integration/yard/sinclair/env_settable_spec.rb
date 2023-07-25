# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  describe '#yard' do
    subject(:settable) { Class.new(MyAppClient) }

    before do
      ENV['MY_APP_USERNAME'] = 'my_login'
      ENV['MY_APP_PORT'] = '8080'
    end

    after do
      ENV.delete('MY_APP_USERNAME')
      ENV.delete('MY_APP_PORT')
    end

    it 'retrieves data from env' do
      expect(settable.username).to eq('my_login')
      expect(settable.password).to be_nil
      expect(settable.host).to eq('my-host.com')
      expect(settable.port).to eq(8080)
    end
  end
end
