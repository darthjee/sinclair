# frozen_string_literal: true

require 'spec_helper'

xdescribe Sinclair::MethodDefinition::InstanceBlockDefinition do
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#build' do
    subject(:method_definition) do
      described_class.new(method_name) do
        @x = @x.to_i + 1
      end
    end

    let(:method_name) { :the_method }

    it_behaves_like 'MethodDefinition#build without cache'

    context 'with cached options' do
      subject(:method_definition) do
        described_class.from(method_name, cached: cached_option) do
          @x = @x.to_i + 1
        end
      end

      it_behaves_like 'MethodDefinition#build with cache options'
    end
  end
end

