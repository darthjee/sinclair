# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition do
  let(:method_name) { :the_method }

  describe '.build' do
    subject(:definition) do
      definition_class.new(method_name, **options)
    end

    let(:definition_class) { Class.new(described_class) }
    let(:options)          { {} }
    let(:klass)            { Class.new }
    let(:type)             { Sinclair::MethodBuilder::CLASS_METHOD }

    context 'when the builder has not been defined' do
      it do
        expect { definition.build(klass, type) }
          .to raise_error(NotImplementedError)
      end
    end

    context 'when the builder has been defined' do
      let(:definition_class) do
        Class.new(described_class) do
          attr_reader :name

          def initialize(name)
            super
            @name = name
          end

          def code_definition
            <<-CODE
            def #{name}
              10
            end
            CODE
          end
        end
      end

      before do
        definition_class.build_with(Sinclair::MethodBuilder::StringMethodBuilder)
      end

      it do
        expect { definition.build(klass, type) }
          .not_to raise_error
      end

      it 'builds the method using the builder' do
        expect { definition.build(klass, type) }
          .to add_class_method(method_name).to(klass)
      end
    end
  end

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

  describe '.for' do
    let(:klass) { Class.new }

    context 'when there are no options nor block' do
      let(:type)      { :call }
      let(:arguments) { %i[attr_reader some_attribute other_attribute] }

      it do
        expect(described_class.for(type, *arguments))
          .to be_a(described_class)
      end

      it 'Returns an instance of the given type' do
        expect(described_class.for(type, *arguments))
          .to be_a(described_class::CallDefinition)
      end

      it 'initializes it correctly' do
        expect { klass.module_eval(&described_class.for(type, *arguments).code_block) }
          .to add_method(:some_attribute).to(klass)
      end
    end

    context 'when type is not given' do
      let(:type)        { nil }
      let(:method_name) { :the_method }
      let(:block)       { proc { 10 } }

      it do
        expect(described_class.for(type, method_name, &block))
          .to be_a(described_class)
      end

      it 'infers the definition from arguments' do
        expect(described_class.for(type, method_name, &block))
          .to be_a(described_class::BlockDefinition)
      end

      it 'initializes it correctly' do
        expect(described_class.for(type, method_name, &block).name)
          .to eq(method_name)
      end
    end

    context 'when a block is given' do
      let(:type)        { :block }
      let(:method_name) { :the_method }
      let(:block)       { proc { 10 } }

      it do
        expect(described_class.for(type, method_name, &block))
          .to be_a(described_class)
      end

      it 'Returns an instance of the given type' do
        expect(described_class.for(type, method_name, &block))
          .to be_a(described_class::BlockDefinition)
      end

      it 'initializes it correctly' do
        expect(described_class.for(type, method_name, &block).name)
          .to eq(method_name)
      end
    end

    context 'when options are given' do
      let(:type)        { :string }
      let(:method_name) { :the_method }
      let(:code)        { '10' }

      it do
        expect(described_class.for(type, method_name, code))
          .to be_a(described_class)
      end

      it 'Returns an instance of the given type' do
        expect(described_class.for(type, method_name, code))
          .to be_a(described_class::StringDefinition)
      end

      it 'initializes it correctly' do
        expect(described_class.for(type, method_name, code).name)
          .to eq(method_name)
      end
    end
  end
end
