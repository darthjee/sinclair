# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ChainSettable do
  subject(:settable) do
    options = options_hash
    Class.new do
      extend Sinclair::ChainSettable

      source :app_client, Class.new(NonDefaultAppClient)
      source :my_app_client, Class.new(MyAppClient)

      setting_with_options :username, :password, :host, :port, **options
    end
  end

  let(:options_hash) { {} }
  let(:username)     { 'my_login' }
  let(:password)     { Random.rand(10_000).to_s }

  context 'when the first setting finds the data' do
    let(:username_key) { 'USERNAME' }
    let(:password_key) { 'PASSWORD' }
    let(:host_key)     { 'HOST' }
    let(:port_key)     { 'PORT' }

    it_behaves_like 'settings reading'
  end

  context 'when the second setting finds the data' do
    let(:username_key) { 'MY_APP_USERNAME' }
    let(:password_key) { 'MY_APP_PASSWORD' }
    let(:host_key)     { 'MY_APP_HOST' }
    let(:port_key)     { 'MY_APP_PORT' }

    it_behaves_like 'settings reading'
  end

  context 'when both have a value' do
    let(:first_host) { 'first_host' }
    let(:second_host) { 'second_host' }

    before do
      ENV['HOST'] = first_host
      ENV['MY_APP_HOST'] = second_host
    end

    after do
      ENV.delete('HOST')
      ENV.delete('MY_APP_HOST')
    end

    it 'returns the first value' do
      expect(settable.host).to eq(first_host)
    end

    context 'when passing a different source as options' do
      let(:options_hash) { { sources: %i[my_app_client app_client] } }

      it 'returns the second value' do
        expect(settable.host).to eq(second_host)
      end
    end
  end
end
