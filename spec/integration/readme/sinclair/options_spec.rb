# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options do
  describe 'readme' do
    it 'creates options object' do
      options = ConnectionOptions.new(
        timeout: 10,
        protocol: 'http'
      )

      expect(options.timeout).to eq(10)
      expect(options.retries).to eq(nil)
      expect(options.protocol).to eq('http')
      expect(options.port).to eq(443)
    end
  end
end
