# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinitions do
  subject(:definitions) { described_class.new }

  describe '#add' do
    let(:name)  { :the_method }
    let(:klass) { Class.new }

    context 'when passing block' do
      it 'returns the resulting array' do
        expect(definitions.add(name) { RandomGenerator.rand })
          .to be_a(Array)
      end

      it 'returns an array of MethodDefinition' do
        expect(definitions.add(name) { RandomGenerator.rand }.first)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new BlockDefinition' do
        expect(definitions.add(name) { RandomGenerator.rand }.first)
          .to be_a(Sinclair::MethodDefinition::BlockDefinition)
      end
    end

    context 'when passing string' do
      it 'returns the resulting array' do
        expect(definitions.add(name, 'RandomGenerator.rand'))
          .to be_a(Array)
      end

      it 'returns an array of MethodDefinition' do
        expect(definitions.add(name, 'RandomGenerator.rand').last)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new StringDefinition' do
        expect(definitions.add(name, 'RandomGenerator.rand').last)
          .to be_a(Sinclair::MethodDefinition::StringDefinition)
      end
    end

    context 'when there are no options nor block' do
      let(:type)      { :call }
      let(:arguments) { %i[attr_reader some_attribute other_attribute] }

      it do
        expect(definitions.add(*arguments, type:))
          .to be_a(Array)
      end

      it 'creates a new definition' do
        expect(definitions.add(*arguments, type:).last)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new definition of the chosen type' do
        expect(definitions.add(*arguments, type:).last)
          .to be_a(Sinclair::MethodDefinition::CallDefinition)
      end

      it 'initializes it correctly' do
        expect { klass.module_eval(&definitions.add(*arguments, type:).last.code_block) }
          .to add_method(:some_attribute).to(klass)
      end
    end

    context 'when a block is given' do
      let(:type)        { :block }
      let(:method_name) { :the_method }
      let(:block)       { proc { 10 } }

      it do
        expect(definitions.add(type, method_name, &block))
          .to be_a(Array)
      end

      it 'creates a new definition' do
        expect(definitions.add(type, method_name, &block).last)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new definition of the chosen type' do
        expect(definitions.add(type, method_name, &block).last)
          .to be_a(Sinclair::MethodDefinition::BlockDefinition)
      end

      it 'initializes it correctly' do
        expect(definitions.add(method_name, type:, &block).last.name)
          .to eq(method_name)
      end
    end

    context 'when options are given' do
      let(:type)        { :string }
      let(:method_name) { :the_method }
      let(:code)        { '10' }

      it do
        expect(definitions.add(method_name, code, type:))
          .to be_a(Array)
      end

      it 'creates a new definition' do
        expect(definitions.add(method_name, code, type:).last)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new definition of the chosen type' do
        expect(definitions.add(method_name, code, type:).last)
          .to be_a(Sinclair::MethodDefinition::StringDefinition)
      end

      it 'initializes it correctly' do
        expect(definitions.add(method_name, code, type:).last.name)
          .to eq(method_name)
      end
    end
  end
end
