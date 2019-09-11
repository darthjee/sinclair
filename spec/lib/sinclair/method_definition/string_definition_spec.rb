# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::StringDefinition do
  subject(:definition) do
    described_class.new(method_name, code, **options)
  end

  let(:method_name) { :the_method }
  let(:code)        { 'Random.rand' }
  let(:options)     { {} }

  describe '#code_line' do
    let(:klass)     { Class.new }
    let(:instance)  { klass.new }
    let(:code_line) { definition.code_line }

    it 'returns the code' do
      expect(definition.code_line).to eq(code)
    end

    it 'returns a code with no cache' do
      expect(instance.instance_eval(code_line))
        .not_to eq(instance.instance_eval(code_line))
    end

    context 'when cache true is given' do
      let(:options) { { cached: true } }

      it 'returns the code with simple cache' do
        expect(definition.code_line)
          .to eq("@#{method_name} ||= #{code}")
      end

      it 'returns a code with cache' do
        expect(instance.instance_eval(code_line))
          .to eq(instance.instance_eval(code_line))
      end

      it 'returns a code that does not cache nil' do
        instance.instance_variable_set("@#{method_name}", nil)

        expect(instance.instance_eval(code_line)).not_to be_nil
      end
    end

    context 'when cache full is given' do
      let(:options) { { cached: :full } }
      let(:expected) do
        "defined?(@#{method_name}) ? @#{method_name} : (@#{method_name} = #{code})"
      end

      it 'returns the code with full cache' do
        expect(definition.code_line).to eq(expected)
      end

      it 'returns a code with cache' do
        expect(instance.instance_eval(code_line))
          .to eq(instance.instance_eval(code_line))
      end

      it 'returns a code that caches nil' do
        instance.instance_variable_set("@#{method_name}", nil)

        expect(instance.instance_eval(code_line)).to be_nil
      end
    end
  end
end
