# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  subject(:settable) { AppClient }

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10000).to_s }

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
end
