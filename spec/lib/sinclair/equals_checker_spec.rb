# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::EqualsChecker do
  subject(:checker) { described_class.new(attributes) }

  let(:attributes) { %i[] }

  let(:model1_class) { SampleModel }
  let(:model2_class) { SampleModel }
  let(:model1)       { model1_class.new(**model1_attributes) }
  let(:model2)       { model2_class.new(**model2_attributes) }

  let(:model1_attributes) { { name: name1, age: age1 } }
  let(:model2_attributes) { { name: name2, age: age2 } }
  let(:name1)             { SecureRandom.hex(10) }
  let(:name2)             { SecureRandom.hex(10) }
  let(:age1)              { Random.rand(10..20) }
  let(:age2)              { Random.rand(21..50) }

  describe 'match?' do
    context 'when the attributes is empty' do
      context 'when they are different classes and attributes are the same' do
        let(:model2_class) { Class.new(SampleModel) }
        let(:name2)        { name1 }
        let(:age2)         { age1 }

        it do
          expect(checker).not_to be_match(model1, model2)
        end
      end

      context 'when the models have the same attributes' do
        let(:name2) { name1 }
        let(:age2)  { age1 }

        it do
          expect(checker).to be_match(model1, model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(checker).to be_match(model1, model2)
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
          expect(checker).not_to be_match(model1, model2)
        end
      end

      context 'when the models have a non listed different attribute' do
        let(:name2) { name1 }

        it do
          expect(checker).to be_match(model1, model2)
        end
      end

      context 'when the models have a listed different attribute' do
        let(:age2) { age1 }

        it do
          expect(checker).not_to be_match(model1, model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(checker).not_to be_match(model1, model2)
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
          expect(checker).not_to be_match(model1, model2)
        end
      end

      context 'when the models have the same attributes' do
        let(:name2) { name1 }
        let(:age2)  { age1 }

        it do
          expect(checker).to be_match(model1, model2)
        end
      end

      context 'when the models have a listed different attribute' do
        let(:name) { name1 }

        it do
          expect(checker).not_to be_match(model1, model2)
        end
      end

      context 'when the models have very different attributes' do
        it do
          expect(checker).not_to be_match(model1, model2)
        end
      end
    end

    context 'when one of the attributes is an instance variable' do
      let(:attributes) { [:name, :@age] }

      context 'when the instance variable is different and the method the same' do
        let(:name2) { name1 }

        it do
          expect(checker).not_to be_match(model1, model2)
        end
      end
    end
  end

  describe '#add' do
    let(:attributes)     { [:name] }
    let(:new_attributes) { [:age] }

    context 'when the new field has different values' do
      let(:name2) { name1 }

      it 'uses the new field to the match' do
        expect { checker.add(new_attributes) }
          .to change { checker.match?(model1, model2) }
          .from(true).to(false)
      end
    end

    context 'when the old field has different values' do
      let(:age2) { age1 }

      it 'uses the new field to the match' do
        expect { checker.add(new_attributes) }
          .not_to change { checker.match?(model1, model2) }
          .from(false)
      end
    end
  end
end
