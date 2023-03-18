# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  subject(:model) { klass.new(name: name) }

  let(:name)       { SecureRandom.hex(10) }
  let(:attributes) { %i[name] }
  let(:options)    { {} }

  describe '.for' do
    subject(:klass) { described_class.for(*attributes, **options) }

    it_behaves_like 'sinclair model building'
  end

  describe '.initialize_with' do
    subject(:klass) { Class.new(described_class) }

    context 'when no options are given' do
      it do
        expect { klass.initialize_with(*attributes, **options) }
          .to add_method(:name).to(klass)
      end

      it do
        expect { klass.initialize_with(*attributes, **options) }
          .to add_method(:name=).to(klass)
      end

      it do
        expect { klass.initialize_with(*attributes, **options) }
          .to change_method(:==).on(klass)
      end
    end

    context 'when writter and comparable are not enabled' do
      let(:options) { { writter: false, comparable: false } }

      it do
        expect { klass.initialize_with(*attributes, **options) }
          .to add_method(:name).to(klass)
      end

      it do
        expect { klass.initialize_with(*attributes, **options) }
          .not_to add_method(:name=).to(klass)
      end

      it do
        expect { klass.initialize_with(*attributes, **options) }
          .not_to change_method(:==).on(klass)
      end
    end

    context 'when class is subclass of another model' do
      subject(:model) { klass.new(name: name, age: age) }

      let(:age) { Random.rand(10..20) }

      let(:superclass) do
        Class.new(described_class) do
          initialize_with(:age)
        end
      end

      let(:klass) do
        Class.new(superclass) do
          initialize_with(:name)
        end
      end

      it 'is initialized with both attributes' do
        expect { klass.new(name: name, age: age) }
          .not_to raise_error
      end

      it 'is initializes new attributes' do
        expect(model.name).to eq(name)
      end

      it 'is initializes old attributes' do
        expect(model.age).to eq(age)
      end
    end

    context 'when the build is done' do
      before do
        klass.initialize_with(*attributes, **options)
      end

      it_behaves_like 'sinclair model building'
    end
  end
end
