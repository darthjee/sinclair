# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::NewCallMethodBuilder do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, definition, type: type)
    end

    let(:call_name) { "attr_#{accessor_type}" }

    let(:definition) do
      Sinclair::MethodDefinition::NewCallDefinition.new(call_name, *attributes)
    end

    context 'when method called is attr_accessor' do
      let(:accessor_type) { :accessor }

      it_behaves_like 'a method builder that adds attribute reader'
      it_behaves_like 'a method builder that adds attribute writer'
    end

    context 'when method called is attr_reader' do
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

    context 'when method called is attr_writter' do
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
