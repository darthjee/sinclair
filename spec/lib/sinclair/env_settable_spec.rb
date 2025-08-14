# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  subject(:settable) { Class.new(AppClient) }

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

  let(:username_key) { 'USERNAME' }
  let(:password_key) { 'PASSWORD' }
  let(:host_key)     { 'HOST' }
  let(:port_key)     { 'PORT' }
  let(:domain_key)   { 'DOMAIN' }
  let(:secret_key)   { 'SECRET' }

  it_behaves_like 'settings reading'

  context 'when defining a prefix' do
    subject(:settable) { Class.new(MyAppClient) }

    let(:username_key) { 'MY_APP_USERNAME' }
    let(:password_key) { 'MY_APP_PASSWORD' }
    let(:host_key)     { 'MY_APP_HOST' }
    let(:port_key)     { 'MY_APP_PORT' }
    let(:domain_key)   { 'MY_APP_DOMAIN' }
    let(:secret_key)   { 'MY_APP_SECRET' }

    it_behaves_like 'settings reading'
  end
end
