# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EqualsChecker::Reader do
  subject(:reader) { described_class.new(attribute) }

  let(:attribute) { :information }
  let(:model)     { SampleModel.new(name: name, age: age) }
  let(:name)      { 'The Name' }
  let(:age)       { 25 }

  describe '.attributes_match?' do
    let(:other)      { SampleModel.new(name: other_name) }
    let(:attribute)  { :name }

    context 'when the value match' do
      let(:other_name) { name }

      it do
        expect(described_class)
          .to be_attributes_match(attribute, model, other)
      end
    end

    context 'when the value does not match' do
      let(:other_name) { 'Other Name' }

      it do
        expect(described_class)
          .to be_attributes_match(attribute, model, other)
      end
    end
  end

  describe '#read_from' do
    context 'when reading from a method' do
      it 'returns the value from the method' do
        expect(reader.read_from(model)).to eq('The Name: 25 yo')
      end
    end

    context 'when reading from a variable' do
      let(:attribute) { :@inner_variable }

      before do
        model.instance_variable_set(:@inner_variable, 301)
      end

      it 'returns the value from the variable' do
        expect(reader.read_from(model)).to eq(301)
      end
    end
  end
end
