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

    context 'when casting to seconds' do
      it 'converts string to seconds duration' do
        result = described_class.cast('300', :seconds)
        expect(result).to eq(300.seconds)
        expect(result).to be_a(ActiveSupport::Duration)
      end

      it 'converts integer to seconds duration' do
        result = described_class.cast(60, :seconds)
        expect(result).to eq(60.seconds)
        expect(result).to be_a(ActiveSupport::Duration)
      end
    end

    context 'when casting to boolean' do
      it 'converts string "true" to boolean true' do
        expect(described_class.cast('true', :boolean)).to be true
      end

      it 'converts string "TRUE" to boolean true' do
        expect(described_class.cast('TRUE', :boolean)).to be true
      end

      it 'converts string "false" to boolean false' do
        expect(described_class.cast('false', :boolean)).to be false
      end

      it 'converts string "FALSE" to boolean false' do
        expect(described_class.cast('FALSE', :boolean)).to be false
      end

      it 'converts any other string to boolean false' do
        expect(described_class.cast('anything', :boolean)).to be false
      end

      it 'converts nil to boolean false' do
        expect(described_class.cast('anything', :boolean)).to be false
      end
    end

    context 'when casting with unknown type' do
      it 'returns the original value' do
        expect(described_class.cast('value', :unknown)).to eq('value')
      end
    end
  end
end