# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ParameterBuilder do
  describe '.from' do
    let(:parameters) { nil }
    let(:named_parameters) { nil }

    context 'when parameters and named_parameters are nil' do
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

    context 'when named_parameters is empty' do
      let(:named_parameters) { [] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('')
      end
    end

    context 'when parameters has no default values' do
      let(:parameters) { [:x, :y] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x, y)')
      end
    end

    xcontext 'when named_parameters has no default values' do
      let(:named_parameters) { [:x, :y] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x:, y:)')
      end
    end

    context 'when parameters has only default values' do
      let(:parameters) { [{ x: 1, y: 3 }] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x = 1, y = 3)')
      end
    end

    xcontext 'when named parameters has only default values' do
      let(:named_parameters) { [{ x: 1, y: 3 }] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x: 1, y: 3)')
      end
    end

    xcontext 'when all options are present' do
      let(:parameters) { [:x, { y: 2 }] }
      let(:named_parameters) { [:a, { b: 3 }] }

      it do
        expect(described_class.from(parameters, named_parameters))
          .to eq('(x, y = 2, a:, b: 3)')
      end
    end
  end
end
