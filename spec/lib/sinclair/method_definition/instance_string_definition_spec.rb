# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::InstanceStringDefinition do
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#build' do
    subject(:method_definition) do
      described_class.new(method_name, code)
    end

    let(:method_name) { :the_method }

    let(:code) { '@x = @x.to_i + 1' }

    it_behaves_like 'MethodDefinition#build without cache'

    context 'with cached options' do
      subject(:method_definition) do
        described_class.from(method_name, code, cached: cached_option)
      end

      it_behaves_like 'MethodDefinition#build with cache options'
    end
  end
end
