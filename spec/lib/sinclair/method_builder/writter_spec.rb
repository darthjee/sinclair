# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Writer do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, *attributes, type: type)
    end

    it_behaves_like 'a method builder that adds attribute witter' do
      context 'when type is instance' do
        let(:type) { Sinclair::MethodBuilder::INSTANCE_METHOD }

        it 'does not add a reader' do
          expect { builder.build }
            .not_to add_method(method_name)
            .to(instance)
        end
      end

      context 'when type is class' do
        let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

        it 'does not add a reader' do
          expect { builder.build }
            .not_to add_class_method(method_name)
            .to(klass)
        end
      end
    end
  end
end
