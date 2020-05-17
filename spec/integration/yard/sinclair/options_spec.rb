# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options do
  describe 'yard' do
    describe 'usage' do
      it 'creates options object' do
        options = ConnectionOptions.new(retries: 10, port: 8080)

        expect(options.timeout).to be_nil
        expect(options.retries).to eq(10)
        expect(options.port).to eq(8080)
        expect(options.protocol).to eq('https')
      end
    end

    describe '#to_h' do
      it 'returns options hash' do
        options = ConnectionOptions.new(retries: 10, port: 8080)

        expect(options.to_h)
          .to eq({ port: 8080, retries: 10, timeout: nil, protocol: 'https' })
      end
    end
  end
end
