# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ParameterBuilder do
  describe '.from' do
    let(:parameters) { nil }
    let(:named_parameters) { nil }

    context 'when parameters is nil' do
      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('')
      end
    end

    context 'when parameters is empty' do
      let(:parameters) { [] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('')
      end
    end

    context 'when parameters has no default values' do
      let(:parameters) { [:x, { y: 1 }] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x, y = 1)')
      end
    end

    context 'when parameters has only default values' do
      let(:parameters) { [{ x: 1, y: 3 }] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x = 1, y = 3)')
      end
    end
  end
end
