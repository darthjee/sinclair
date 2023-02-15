# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::CallDefinition do
  subject(:definition) do
    described_class.new(call_name, *attributes)
  end

  let(:call_name)  { :method_call }
  let(:attributes) { %i[key1 value2] }

  describe '#code_string' do
    let(:expected) { 'method_call :key1, :value2' }

    it 'returns the code string' do
      expect(definition.code_string)
        .to eq(expected)
    end
  end

  describe '#class_code_string' do
    let(:expected) do
      <<-RUBY
      class << self
        method_call :key1, :value2
      end
      RUBY
    end

    it 'returns the code string' do
      expect(definition.class_code_string.gsub(/^ */, ''))
        .to eq(expected.gsub(/^ */, ''))
    end
  end
end
