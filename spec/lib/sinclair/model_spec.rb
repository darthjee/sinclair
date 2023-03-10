# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  subject(:model) { model_class.new }

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
