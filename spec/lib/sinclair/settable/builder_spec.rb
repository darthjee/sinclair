# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable::Builder do
  subject(:settable) do
    setting_prefix = prefix

    Class.new do
      extend Sinclair::EnvSettable

      settings_prefix setting_prefix
    end
  end

  let(:username)   { 'my_login' }
  let(:password)   { Random.rand(10_000).to_s }
  let(:settings)   { %i[username password] }
  let(:options)    { { prefix: prefix } }

  let(:builder) do
    described_class.new(settable, Sinclair::EnvSettable, *settings, **options)
  end

  before { builder.build }

  context 'when not using prefix' do
    let(:prefix) { nil }

    let(:username_key) { 'USERNAME' }
    let(:password_key) { 'PASSWORD' }
    let(:host_key)     { 'HOST' }
    let(:port_key)     { 'PORT' }

    it_behaves_like 'settings reading from env'
  end

  context 'when defining a prefix' do
    let(:prefix)       { 'MY_APP' }
    let(:username_key) { 'MY_APP_USERNAME' }
    let(:password_key) { 'MY_APP_PASSWORD' }
    let(:host_key)     { 'MY_APP_HOST' }
    let(:port_key)     { 'MY_APP_PORT' }

    it_behaves_like 'settings reading from env'
  end
end
