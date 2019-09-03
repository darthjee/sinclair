# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition do
  let(:method_name) { :the_method }

  describe '.default_value' do
    subject(:klass) { Class.new(described_class) }

    let(:value)       { Random.rand }
    let(:instance)    { klass.new(:other_method) }

    it do
      expect { klass.default_value(method_name, value) }
        .to add_method(method_name).to(klass)
    end

    context 'when method is defined and called' do
      before do
        klass.default_value(method_name, value)
      end

      it 'adds method that always return given value' do
        expect(instance.the_method).to eq(value)
      end
    end
  end

  describe '.from' do
    context 'when passing a block' do
      it do
        expect(described_class.from(method_name) { 1 })
          .to be_a(described_class::BlockDefinition)
      end
    end

    context 'when passing string' do
      it do
        expect(described_class.from(method_name, 'code'))
          .to be_a(described_class::StringDefinition)
      end
    end
  end
end
