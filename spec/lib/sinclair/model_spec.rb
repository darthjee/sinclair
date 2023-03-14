# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  subject(:model) { model_class.new(name: nil) }

  let(:model_class) { Class.new(described_class) }

  describe '.with_attributes' do
    context 'when the call happens with no options' do
      it do
        expect { model_class.with_attributes(:name) }
          .to add_method(:name).to(model_class)
      end

      it do
        expect { model_class.with_attributes(:name) }
          .to add_method(:name=).to(model_class)
      end

      it 'Adds required keyword' do
        expect { model_class.with_attributes(:name) }
          .to change { model_class.new rescue nil }
          .from(model_class).to(nil)
      end

      context 'When a field has been added already' do
        before do
          model_class.with_attributes(:name)
        end

        it 'Adds required keyword' do
          expect { model_class.with_attributes(:age) }
            .to change { model_class.new(name: 'Some Name') rescue nil }
            .from(model_class).to(nil)
        end

        it 'Does not remove old required keyword' do
          expect { model_class.with_attributes(:age) }
            .to change { model_class.new(name: 'Some Name', age: 21) rescue nil }
            .from(nil).to(model_class)
        end
      end

      context 'when reader is called' do
        let(:name) { SecureRandom.hex(10) }

        before do
          model_class.with_attributes(:name)
          model.instance_variable_set(:@name, name)
        end

        it do
          expect(model.name).to eq(name)
        end
      end

      context 'when setter is called' do
        let(:name) { SecureRandom.hex(10) }

        before do
          model_class.with_attributes(:name)
        end

        it do
          expect { model.name = name }
            .to change { model.instance_variable_get(:@name) }
            .from(nil)
            .to(name)
        end
      end
    end
  end
end
