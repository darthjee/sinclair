# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ChainSettable do
  subject(:settable) do
    Class.new do
      extend Sinclair::ChainSettable

      source :app_client, Class.new(AppClient)
      source :app_client, Class.new(MyAppClient)

      with_settings :username, :password, :host, :port
    end
  end

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

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
end
