# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition do
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#build' do
    let(:method_name) { :the_method }

    context 'when instantiating the class itself' do
      subject(:method_definition) do
        described_class.new(method_name)
      end

      it do
        expect { method_definition.build(klass) }
          .to raise_error(RuntimeError, 'Not implemented yet')
      end
    end

    context 'when method was defined with a string' do
      subject(:method_definition) do
        described_class.from(method_name, code)
      end

      let(:code) { '@x = @x.to_i + 1' }

      it_behaves_like 'MethodDefinition#build without cache'

      context 'with cached options' do
        subject(:method_definition) do
          described_class.from(method_name, code, cached: true)
        end

        it_behaves_like 'MethodDefinition#build with cache'
      end
    end

    context 'when method was defined with a block' do
      subject(:method_definition) do
        described_class.from(method_name) do
          @x = @x.to_i + 1
        end
      end

      it_behaves_like 'MethodDefinition#build without cache'

      context 'with cached options' do
        subject(:method_definition) do
          described_class.from(method_name, cached: true) do
            @x = @x.to_i + 1
          end
        end

        it_behaves_like 'MethodDefinition#build with cache'
      end
    end
  end
end
