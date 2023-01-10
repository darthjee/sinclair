# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EqualsChecker do
  describe '#yard' do
    it 'regular usage' do
      checker = Sinclair::EqualsChecker.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = SampleModel.new(name: 'rose', age: 23)

      expect(checker.match?(model1, model2)).to be_falsey
    end

    it 'similar models' do
      checker = Sinclair::EqualsChecker.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = SampleModel.new(name: 'jack', age: 21)

      expect(checker.match?(model1, model2)).to be_truthy
    end

    it 'different classes' do
      checker = Sinclair::EqualsChecker.new(:name, :age)

      model1 = SampleModel.new(name: 'jack', age: 21)
      model2 = OtherModel.new(name: 'jack', age: 21)

      expect(checker.match?(model1, model2)).to be_falsey
    end
  end
end
