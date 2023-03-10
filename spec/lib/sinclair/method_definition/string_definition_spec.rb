# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::StringDefinition do
  subject(:definition) do
    described_class.new(method_name, code, **options)
  end

  let(:method_name) { :the_method }
  let(:code)        { 'Random.rand' }
  let(:options)     { {} }

  describe '#code_definition' do
    let(:klass)     { Class.new }
    let(:instance)  { klass.new }
    let(:code_definition) { definition.code_definition }
    let(:expected_code) do
      <<-CODE
      def #{method_name}
        #{code}
      end
      CODE
    end

    it 'returns a code with no cache' do
      expect(definition.code_definition.gsub(/^ */, ''))
        .to eq(expected_code.gsub(/^ */, ''))
    end

    context 'when cache true is given' do
      let(:options) { { cached: true } }
      let(:expected_code) do
        <<-CODE
        def #{method_name}
          @#{method_name} ||= #{code}
        end
        CODE
      end

      it 'returns the code with simple cache' do
        expect(definition.code_definition.gsub(/^ */, ''))
          .to eq(expected_code.gsub(/^ */, ''))
      end
    end

    context 'when cache full is given' do
      let(:options) { { cached: :full } }
      let(:expected) do
        <<-CODE
        def #{method_name}
          defined?(@#{method_name}) ? @#{method_name} : (@#{method_name} = #{code})
        end
        CODE
      end

      it 'returns the code with full cache' do
        expect(definition.code_definition.gsub(/^ */, '')).to eq(expected.gsub(/^ */, ''))
      end

      it 'returns a code with cache' do
        expect(instance.instance_eval(code_definition))
          .to eq(instance.instance_eval(code_definition))
      end
    end
  end
end
