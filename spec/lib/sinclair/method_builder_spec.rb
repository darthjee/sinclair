# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder do
  subject(:builder) { described_class.new(klass) }

  let(:klass)       { Class.new }
  let(:definitions) { Sinclair::MethodDefinitions.new }
  let(:value)       { Random.rand }
  let(:method_name) { :the_method }
  let(:instance)    { klass.new }

  describe '#build_methods' do
    context 'when the method is a string definition' do
      before do
        definitions.add(method_name, value.to_s)
      end

      context 'when building an instance method' do
        let(:type) { described_class::INSTANCE_METHOD }

        it do
          expect { builder.build_methods(definitions, type) }
            .to add_method(method_name).to(instance)
        end

        context 'when the method is called' do
          before { builder.build_methods(definitions, type) }

          it do
            expect(instance.the_method).to eq(value)
          end
        end
      end

      context 'when building a class method' do
        let(:type) { described_class::CLASS_METHOD }

        it do
          expect { builder.build_methods(definitions, type) }
            .to add_class_method(method_name).to(klass)
        end

        context 'when the method is called' do
          before { builder.build_methods(definitions, type) }

          it do
            expect(klass.the_method).to eq(value)
          end
        end
      end
    end

    context 'when the method is a block definition' do
      before do
        result = value
        definitions.add(method_name) { result }
      end

      context 'when building an instance method' do
        let(:type) { described_class::INSTANCE_METHOD }

        it do
          expect { builder.build_methods(definitions, type) }
            .to add_method(method_name).to(instance)
        end

        context 'when the method is called' do
          before { builder.build_methods(definitions, type) }

          it do
            expect(instance.the_method).to eq(value)
          end
        end
      end

      context 'when building a class method' do
        let(:type) { described_class::CLASS_METHOD }

        it do
          expect { builder.build_methods(definitions, type) }
            .to add_class_method(method_name).to(klass)
        end

        context 'when the method is called' do
          before { builder.build_methods(definitions, type) }

          it do
            expect(klass.the_method).to eq(value)
          end
        end
      end
    end
  end
end
