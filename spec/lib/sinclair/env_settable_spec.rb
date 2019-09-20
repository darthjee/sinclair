# frozen_string_literal: true

require 'spec_helper'

shared_examples 'settings reading from env' do
  before do
    ENV[username_key] = username
    ENV[password_key] = password
  end

  after do
    ENV.delete(username_key)
    ENV.delete(password_key)
  end

  it 'retrieves username from env' do
    expect(settable.username).to eq(username)
  end

  it 'retrieves password from env' do
    expect(settable.password).to eq(password)
  end

  context 'when defining defaults' do
    it 'returns default value' do
      expect(settable.host).to eq('my-host.com')
    end

    context 'when setting the env variable' do
      let(:other_host) { 'other-host.com' }

      before do
        ENV[host_key] = other_host
      end

      after do
        ENV.delete(host_key)
      end

      it 'retrieves host from env' do
        expect(settable.host).to eq(other_host)
      end
    end
  end
end

describe Sinclair::EnvSettable do
  subject(:settable) { Class.new(AppClient) }

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

  let(:username_key) { 'USERNAME' }
  let(:password_key) { 'PASSWORD' }
  let(:host_key)     { 'HOST' }

  it_behaves_like 'settings reading from env'

  context 'when defining a prefix' do
    subject(:settable) { Class.new(MyAppClient) }

    let(:username_key) { 'MY_APP_USERNAME' }
    let(:password_key) { 'MY_APP_PASSWORD' }
    let(:host_key)     { 'MY_APP_HOST' }

    it_behaves_like 'settings reading from env'
  end
end
