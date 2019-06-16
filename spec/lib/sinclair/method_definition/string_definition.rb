# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::StringDefinition do
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#build' do
    let(:method_name) { :the_method }

    subject(:method_definition) do
      described_class.new(method_name, code)
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
end
