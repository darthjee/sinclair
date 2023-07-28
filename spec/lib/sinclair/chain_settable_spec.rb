# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ChainSettable do
  subject(:settable) do
    Class.new do
      extend Sinclair::ChainSettable

      source :app_client, Class.new(AppClient)

      with_settings :username, :password, :host, :port
    end
  end

  let(:username) { 'my_login' }
  let(:password) { Random.rand(10_000).to_s }

  let(:username_key) { 'USERNAME' }
  let(:password_key) { 'PASSWORD' }
  let(:host_key)     { 'HOST' }
  let(:port_key)     { 'PORT' }

  it_behaves_like 'settings reading'
end
