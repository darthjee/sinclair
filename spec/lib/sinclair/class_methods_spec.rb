# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ClassMethods do
  subject(:builder) { builder_class.new(dummy_class, options) }

  let(:options)       { {} }
  let(:instance)      { dummy_class.new }
  let(:dummy_class)   { Class.new }
  let(:builder_class) { Sinclair }

  describe '#build' do
    let(:block) do
      method_name = :some_method
      value = 1

      proc do
        add_method(method_name) { value }
      end
    end

    it 'executes the block and builds' do
      expect { builder_class.build(dummy_class, options, &block) }
        .to add_method(:some_method).to(dummy_class)
    end

    context 'when the method is built and called' do
      before do
        builder_class.build(dummy_class, options, &block)
      end

      it 'returns the value' do
        expect(instance.some_method).to eq(1)
      end
    end
  end
end
