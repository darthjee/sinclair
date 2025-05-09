# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ChainSettable do
  subject(:settable) do
    options = options_hash
    env_setting = env_setting_class

    Class.new do
      extend Sinclair::ChainSettable

      source :app_client, env_setting
      source :my_app_client, Class.new(MyAppClient)

      setting_with_options :username, :password, :host, :port, **options
    end
  end

  let(:env_setting_class) { Class.new(NonDefaultAppClient) }
  let(:options_hash)      { {} }
  let(:username)          { 'my_login' }
  let(:password)          { Random.rand(10_000).to_s }

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
    let(:first_username)  { 'first_username' }
    let(:second_username) { 'second_username' }

    before do
      ENV['USERNAME'] = first_username
      ENV['MY_APP_USERNAME'] = second_username
    end

    after do
      ENV.delete('USERNAME')
      ENV.delete('MY_APP_USERNAME')
    end

    it 'returns the first value' do
      expect(settable.username).to eq(first_username)
    end

    context 'when passing a different source as options' do
      let(:options_hash) { { sources: %i[my_app_client app_client] } }

      it 'returns the second value' do
        expect(settable.username).to eq(second_username)
      end
    end
  end

  context 'when none has value' do
    let(:default)      { 'some_default_username' }
    let(:options_hash) { { default: } }

    it 'returns the first value' do
      expect(settable.username).to eq(default)
    end
  end

  context 'when there is a subclass with diferent sources' do
    subject(:second_settable) do
      env_setting = second_env_setting_class

      Class.new(settable) do
        source :app_client, env_setting
        source :my_app_client, Class.new(MyAppClient)
      end
    end

    let(:first_username)  { 'first_username' }
    let(:second_username) { 'second_username' }
    let(:second_env_setting_class) do
      Class.new(MyAppClient)
    end

    before do
      ENV['USERNAME'] = first_username
      ENV['MY_APP_USERNAME'] = second_username
    end

    after do
      ENV.delete('USERNAME')
      ENV.delete('MY_APP_USERNAME')
    end

    it 'returns different values' do
      expect(settable.username).not_to eq(second_settable.username)
    end
  end
end
