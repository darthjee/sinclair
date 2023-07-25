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
  let(:read_block) { Sinclair::EnvSettable.read_with }

  let(:builder) do
    described_class.new(settable, read_block, :username, :password, host: 'my-host.com')
  end

  before { builder.build }

  context 'when not using prefix' do
    let(:prefix) { nil }

    let(:username_key) { 'USERNAME' }
    let(:password_key) { 'PASSWORD' }
    let(:host_key)     { 'HOST' }

    it_behaves_like 'settings reading from env'
  end

  context 'when defining a prefix' do
    let(:prefix)       { 'MY_APP' }
    let(:username_key) { 'MY_APP_USERNAME' }
    let(:password_key) { 'MY_APP_PASSWORD' }
    let(:host_key)     { 'MY_APP_HOST' }

    it_behaves_like 'settings reading from env'
  end
end
