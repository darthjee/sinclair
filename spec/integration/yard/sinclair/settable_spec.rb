# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable do
  describe '#yard' do
    subject(:settable) { HashAppClient }

    before do
      HashAppClient::HASH[:username] = 'my_login'
      HashAppClient::HASH[:port] = '8080'
    end

    after do
      HashAppClient::HASH.delete(:username)
      HashAppClient::HASH.delete(:port)
    end

    it 'retrieves data from env' do
      expect(settable.username).to eq('my_login')
      expect(settable.password).to be_nil
      expect(settable.host).to eq('my-host.com')
      expect(settable.port).to eq(8080)
    end
  end
end
