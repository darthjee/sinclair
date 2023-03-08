# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::CallDefinition do
  subject(:definition) do
    described_class.new(call_name, *attributes)
  end

  let(:call_name)  { :method_call }
  let(:attributes) { %i[key1 value2] }

  describe '#code_block' do
    let(:instance) { klass.new }
    let(:klass) do
      Class.new do
        def method_call(*args)
          args
        end
      end
    end

    it do
      expect(definition.code_block)
        .to be_a(Proc)
    end

    it 'returns a proc with the method call' do
      expect(instance.instance_eval(&(definition.code_block)))
        .to eq(attributes)
    end
  end
end
