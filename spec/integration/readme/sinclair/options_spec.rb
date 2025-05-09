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
      expect(options.retries).to be_nil
      expect(options.protocol).to eq('http')
      expect(options.port).to eq(443)
    end

    context 'when initialized with invalid options' do
      it do
        expect do
          ConnectionOptions.new(invalid: 10)
        end.to raise_error(Sinclair::Exception::InvalidOptions)
      end
    end
  end
end
