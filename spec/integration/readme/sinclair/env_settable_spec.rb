# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EnvSettable do
  describe 'readme' do
    let(:client) { ServiceClient.default }
    let(:query) do
      /#<ServiceClient:[^ ]* @username="my-login", @password=nil, @port=80, @hostname="host.com">/
    end

    before do
      ENV['SERVICE_USERNAME'] = 'my-login'
      ENV['SERVICE_HOSTNAME'] = 'host.com'
    end

    it 'sets defaults values' do
      expect(client.inspect.to_s).to match(query)
    end
  end
end
