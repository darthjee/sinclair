# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Exception::InvalidOptions do
  describe '#message' do
    let(:exception) { described_class.new(%i[invalid options]) }
    let(:expected_message) do
      'Invalid keys on options initialization (invalid options)'
    end

    it 'shows invalid keys' do
      expect(exception.message).to eq(expected_message)
    end
  end
end
