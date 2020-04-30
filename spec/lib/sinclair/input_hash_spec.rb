# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::InputHash do
  describe '.input_hash' do
    context 'when arguments are strings and symbols' do
      let(:hash) do
        described_class.input_hash(
          :attribute1,
          'attribute2'
        )
      end

      let(:expected_hash) do
        {
          attribute1: nil,
          'attribute2' => nil
        }
      end

      it 'uses attributes as keys for the hash' do
        expect(hash).to eq(expected_hash)
      end
    end

    context 'when arguments is a hash' do
      let(:hash) do
        described_class.input_hash(expected_hash)
      end

      let(:expected_hash) do
        {
          attribute1: 10,
          'attribute2' => 20
        }
      end

      it 'returns same hash' do
        expect(hash).to eq(expected_hash)
      end
    end

    context 'when arguments is a mix of names and hashes' do
      let(:hash) do
        described_class.input_hash(
          :attribute1, 'attribute2',
          attribute3: 10,
          'attribute4' => 20
        )
      end

      let(:expected_hash) do
        {
          attribute1: nil,
          'attribute2' => nil,
          attribute3: 10,
          'attribute4' => 20
        }
      end

      it 'returns same hash' do
        expect(hash).to eq(expected_hash)
      end
    end
  end
end
