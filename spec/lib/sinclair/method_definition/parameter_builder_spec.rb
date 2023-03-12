# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ParameterBuilder do
  subject(:builder) { described_class.new(parameters) }

  describe '#parameters_string' do
    context 'when parameters is nil' do
      let(:parameters) { nil }

      it do
        expect(builder.parameters_string).to eq('')
      end
    end

    context 'when parameters is empty' do
      let(:parameters) { [] }

      it do
        expect(builder.parameters_string).to eq('')
      end
    end

    context 'when parameters has no default values' do
      let(:parameters) { [:x, { y: 1 }] }

      it do
        expect(builder.parameters_string).to eq('(x, y = 1)')
      end
    end

    context 'when parameters has only default values' do
      let(:parameters) { [{ x: 1, y: 3 }] }

      it do
        expect(builder.parameters_string).to eq('(x = 1, y = 3)')
      end
    end
  end
end
