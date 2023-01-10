# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EqualsBuilder do
  describe '#yard' do
    it 'regular usage' do
      builder = Sinclair::EqualsBuilder.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = SampleModel.new(name: 'rose', age: 23)

      expect(builder.match?(model1, model2)).to be_falsey
    end

    it 'similar models' do
      builder = Sinclair::EqualsBuilder.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = SampleModel.new(name: 'jack', age: 21)

      expect(builder.match?(model1, model2)).to be_truthy
    end

    it 'different classes' do
      builder = Sinclair::EqualsBuilder.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = OtherModel.new(name: 'jack', age: 21)

      expect(builder.match?(model1, model2)).to be_falsey
    end
  end
end
