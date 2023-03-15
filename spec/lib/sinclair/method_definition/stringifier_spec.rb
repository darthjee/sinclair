# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::Stringifier do
  describe '.value_string' do
    context 'when value is nil' do
      it 'returns string representing nil' do
        expect(described_class.value_string(nil)).to eq('nil')
      end
    end

    context 'when value is a symbol' do
      it 'returns string representing a symbol' do
        expect(described_class.value_string(:symbol)).to eq(':symbol')
      end
    end

    context 'when value is a string' do
      it 'returns string representing a string' do
        expect(described_class.value_string('string')).to eq('"string"')
      end
    end

    context 'when value is a number' do
      it 'returns string representing a number' do
        expect(described_class.value_string(10)).to eq('10')
      end
    end

    context 'when value is a float' do
      it 'returns string representing a float' do
        expect(described_class.value_string(1.20)).to eq('1.2')
      end
    end

    context 'when value is a true' do
      it 'returns string representing a true' do
        expect(described_class.value_string(true)).to eq('true')
      end
    end

    context 'when value is a false' do
      it 'returns string representing a false' do
        expect(described_class.value_string(false)).to eq('false')
      end
    end

    context 'when value is a class' do
      it 'returns string representing a class' do
        expect(described_class.value_string(Sinclair::Model)).to eq('Sinclair::Model')
      end
    end

    context 'when value is a hash' do
      it 'returns string representing a Hash' do
        expect(described_class.value_string({ a: 10, 'b' => 'value' }))
          .to eq('{:a=>10, "b"=>"value"}')
      end
    end

    context 'when value is an Array' do
      it 'returns string representing a Array' do
        expect(described_class.value_string([:a, 10, 'b', true, nil]))
          .to eq('[:a, 10, "b", true, nil]')
      end
    end
  end
end
