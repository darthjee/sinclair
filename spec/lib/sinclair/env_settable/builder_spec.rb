# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable::Builder do
  subject(:settable) { Class.new }

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

  let(:builder) do
    described_class.new(settable, prefix, :username, :password, host: 'my-host.com')
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
