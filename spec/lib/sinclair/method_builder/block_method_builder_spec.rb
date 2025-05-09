# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::BlockMethodBuilder do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, definition, type:)
    end

    let(:klass)       { Class.new }
    let(:instance)    { klass.new }
    let(:value)       { Random.rand }
    let(:method_name) { :the_method }

    let(:definition) do
      result = value
      Sinclair::MethodDefinition.from(method_name) { result }
    end

    context 'when type is instance' do
      let(:type) { Sinclair::MethodBuilder::INSTANCE_METHOD }

      it do
        expect { builder.build }
          .to add_method(method_name).to(instance)
      end

      context 'when the method is built' do
        before { builder.build }

        it 'returns the result of the block when called' do
          expect(instance.the_method).to eq(value)
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

        it 'returns the result of the block when called' do
          expect(klass.the_method).to eq(value)
        end
      end
    end
  end
end
