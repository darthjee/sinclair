# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  subject(:settable) { AppClient }

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

  context 'when defining a prefix' do
    subject(:settable) { MyAppClient }

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
  end
end
