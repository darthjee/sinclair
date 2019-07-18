# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ClassMethodDefinition do
  let(:klass) { Class.new }

  describe '#build' do
    let(:method_name) { :the_method }

    context 'when instantiating the class itself' do
      subject(:method_definition) do
        described_class.new(method_name)
      end

      it do
        expect { method_definition.build(klass) }.to raise_error(
          RuntimeError,
          'Build is implemented in subclasses. ' \
          "Use #{described_class}.from to initialize a proper object"
        )
      end
    end

    context 'when method was defined with a string' do
      subject(:method_definition) do
        described_class.from(method_name, code)
      end

      let(:code) { '@x = @x.to_i + 1' }

      it_behaves_like 'ClassMethodDefinition#build without cache'

      context 'with cached options' do
        subject(:method_definition) do
          described_class.from(method_name, code, cached: cached_option)
        end

        it_behaves_like 'ClassMethodDefinition#build with cache options'
      end
    end

    context 'when method was defined with a block' do
      subject(:method_definition) do
        described_class.from(method_name) do
          @x = @x.to_i + 1
        end
      end

      it_behaves_like 'ClassMethodDefinition#build without cache'

      context 'with cached options' do
        subject(:method_definition) do
          described_class.from(method_name, cached: cached_option) do
            @x = @x.to_i + 1
          end
        end

        it_behaves_like 'ClassMethodDefinition#build with cache options'
      end
    end
  end
end
