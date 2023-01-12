require 'spec_helper'

describe Sinclair::EqualsChecker do
  describe '#yard' do
    describe '.comparable_by?' do
      let(:model_class) do
        Class.new(SampleModel) do
          include Sinclair::Comparable

          comparable_by :name, :age
        end
      end

      it 'regular usage' do
        model1 = model_class.new(name: 'jack', age: 21)
        model2 = model_class.new(name: 'rose', age: 23)

        expect(model1 == model2).to be_falsey
      end
    end
  end
end
