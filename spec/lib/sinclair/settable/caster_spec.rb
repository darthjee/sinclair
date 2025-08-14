# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable::Caster do
  describe '.cast' do
    context 'when casting to integer' do
      it 'converts string to integer' do
        expect(described_class.cast('10', :integer)).to eq(10)
      end

      it 'converts float to integer' do
        expect(described_class.cast(10.5, :integer)).to eq(10)
      end
    end

    context 'when casting to string' do
      it 'converts integer to string' do
        expect(described_class.cast(10, :string)).to eq('10')
      end

      it 'converts symbol to string' do
        expect(described_class.cast(:symbol, :string)).to eq('symbol')
      end
    end

    context 'when casting to float' do
      it 'converts string to float' do
        expect(described_class.cast('10.5', :float)).to eq(10.5)
      end

      it 'converts integer to float' do
        expect(described_class.cast(10, :float)).to eq(10.0)
      end
    end

    context 'when casting with unknown type' do
      it 'returns the original value' do
        expect(described_class.cast('value', :unknown)).to eq('value')
      end
    end
  end
end