# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Comparable do
  let(:model_class) do
    Class.new(SampleModel) do
      extend Sinclair::Comparable

      def ==(other)
        self.class.equals_checker.match?(self, other)
      end
    end
  end

  let(:attributes)   { %i[] }
  let(:model1_class) { model_class }
  let(:model2_class) { model_class }
  let(:model1)       { model1_class.new(**model1_attributes) }
  let(:model2)       { model2_class.new(**model2_attributes) }

  let(:model1_attributes) { { name: name1, age: age1 } }
  let(:model2_attributes) { { name: name2, age: age2 } }
  let(:name1)             { SecureRandom.hex(10) }
  let(:name2)             { SecureRandom.hex(10) }
  let(:age1)              { Random.rand(10..20) }
  let(:age2)              { Random.rand(21..50) }

  describe "#==" do
    before do
      model1_class.comparable_by(attributes)
      model2_class.comparable_by(attributes)
    end

    context 'when the attributes is empty' do
      context 'when they are different classes and attributes are the same' do
        let(:model2_class) { Class.new(SampleModel) }
        let(:name2)        { name1 }
        let(:age2)         { age1 }

        it do
          expect(model1).not_to eq(model2)
        end
      end

      context 'when the models have the same attributes' do
        let(:name2) { name1 }
        let(:age2)  { age1 }

        it do
          expect(model1).to eq(model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(model1).to eq(model2)
        end
      end
    end

    context 'when the attributes is missing just one attribute' do
      let(:attributes) { %i[name] }

      context 'when they are different classes and attributes are the same' do
        let(:model2_class) { Class.new(SampleModel) }
        let(:name2)        { name1 }
        let(:age2)         { age1 }

        it do
          expect(model1).not_to eq(model2)
        end
      end

      context 'when the models have a non listed different attribute' do
        let(:name2) { name1 }

        it do
          expect(model1).to eq(model2)
        end
      end

      context 'when the models have a listed different attribute' do
        let(:age2) { age1 }

        it do
          expect(model1).not_to eq(model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(model1).not_to eq(model2)
        end
      end
    end

    context 'when all attributes are included' do
      let(:attributes) { %i[name age] }

      context 'when they are different classes and attributes are the same' do
        let(:model2_class) { Class.new(SampleModel) }
        let(:name2)        { name1 }
        let(:age2)         { age1 }

        it do
          expect(model1).not_to eq(model2)
        end
      end

      context 'when the models have the same attributes' do
        let(:name2) { name1 }
        let(:age2)  { age1 }

        it do
          expect(model1).to eq(model2)
        end
      end

      context 'when the models have a listed different attribute' do
        let(:name) { name1 }

        it do
          expect(model1).not_to eq(model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(model1).not_to eq(model2)
        end
      end
    end
  end
end
