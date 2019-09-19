# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  subject(:settable) { Class.new(AppClient) }

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

  before do
    ENV['USERNAME'] = username
    ENV['PASSWORD'] = password
  end

  after do
    ENV.delete('USERNAME')
    ENV.delete('PASSWORD')
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
        ENV['HOST'] = other_host
      end

      after do
        ENV.delete('host')
      end

      it 'retrieves host from env' do
        expect(settable.host).to eq(other_host)
      end
    end
  end

  context 'when defining a prefix' do
    subject(:settable) { Class.new(MyAppClient) }

    before do
      ENV['MY_APP_USERNAME'] = username
      ENV['MY_APP_PASSWORD'] = password
    end

    after do
      ENV.delete('MY_APP_USERNAME')
      ENV.delete('MY_APP_PASSWORD')
    end

    it 'retrieves username from prefixed env' do
      expect(settable.username).to eq(username)
    end

    it 'retrieves password from prefixed env' do
      expect(settable.password).to eq(password)
    end

    context 'when defining defaults' do
      it 'returns default value' do
        expect(settable.host).to eq('my-host.com')
      end

      context 'when setting the env variable' do
        let(:other_host) { 'other-host.com' }

        before do
          ENV['MY_APP_HOST'] = other_host
        end

        after do
          ENV.delete('host')
        end

        it 'retrieves host from env' do
          expect(settable.host).to eq(other_host)
        end
      end
    end
  end
end
