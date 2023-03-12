# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::StringMethodBuilder do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, definition, type: type)
    end

    let(:klass)       { Class.new }
    let(:instance)    { klass.new }
    let(:value)       { Random.rand }
    let(:method_name) { :the_method }
    let(:code)        { value.to_s }
    let(:options)     { {} }

    let(:definition) do
      Sinclair::MethodDefinition.from(method_name, code, **options)
    end

    context 'when type is instance' do
      let(:type) { Sinclair::MethodBuilder::INSTANCE_METHOD }

      it do
        expect { builder.build }
          .to add_method(method_name).to(instance)
      end

      context 'when the method is built' do
        before { builder.build }

        it 'returns the result of the code when called' do
          expect(instance.the_method).to eq(value)
        end

        it 'creates a method with no parameters' do
          expect(instance.method(method_name).parameters)
            .to be_empty
        end
      end

      context 'when the method is built with parameters' do
        let(:code)    { 'a + b' }
        let(:options) { { parameters: %i[a b] } }

        before { builder.build }

        it 'returns the result of the code when called' do
          expect(instance.the_method(12, 23)).to eq(35)
        end

        it 'creates a method with no parameters' do
          expect(instance.method(method_name).parameters)
            .to eq([%i[req a], %i[req b]])
        end
      end
    end

    context 'when type is class' do
      let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

      it do
        expect { builder.build }
          .to add_class_method(method_name).to(klass)
      end

      context 'when the method is built' do
        before { builder.build }

        it 'returns the result of the code when called' do
          expect(klass.the_method).to eq(value)
        end
      end
    end
  end
end
