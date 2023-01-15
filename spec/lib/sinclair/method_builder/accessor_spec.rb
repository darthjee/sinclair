# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Accessor do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, *attributes, type: type, accessor_type: accessor_type)
    end

    context 'when accesor type is accessor' do
      let(:accessor_type) { :accessor }

      it_behaves_like 'a method builder that adds attribute reader'
      it_behaves_like 'a method builder that adds attribute writer'
    end

    context 'when accesor type is reader' do
      let(:accessor_type) { :reader }

      it_behaves_like 'a method builder that adds attribute reader' do
        context 'when type is instance' do
          let(:type) { Sinclair::MethodBuilder::INSTANCE_METHOD }

          it 'does not add a reader' do
            expect { builder.build }
              .not_to add_method("#{method_name}=")
              .to(instance)
          end
        end

        context 'when type is class' do
          let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

          it 'does not add a reader' do
            expect { builder.build }
              .not_to add_class_method("#{method_name}=")
              .to(klass)
          end
        end
      end
    end

    context 'when accesor type is writer' do
      let(:accessor_type) { :writer }

      it_behaves_like 'a method builder that adds attribute writer' do
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
end
