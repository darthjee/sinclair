# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ClassStringDefinition do
  let(:klass) { Class.new }

  describe '#build' do
    subject(:method_definition) do
      described_class.new(method_name, code)
    end

    let(:method_name) { :the_method }

    let(:code) { '@x = @x.to_i + 1' }

    it_behaves_like 'ClassMethodDefinition#build without cache'

    context 'with cached options' do
      subject(:method_definition) do
        described_class.new(method_name, code, cached: cached_option)
      end

      it_behaves_like 'ClassMethodDefinition#build with cache options'
    end
  end
end
