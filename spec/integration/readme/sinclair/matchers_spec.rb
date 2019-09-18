# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sinclair::Matchers do
  subject(:builder_class) { DefaultValue }

  let(:klass)         { Class.new }
  let(:method)        { :the_method }
  let(:value)         { Random.rand(100) }
  let(:builder)       { builder_class.new(klass, method, value) }
  let(:instance)      { klass.new }

  context 'when the builder runs' do
    it do
      expect { builder.build }.to add_method(method).to(instance)
    end
  end

  context 'when the builder runs' do
    it do
      expect { builder.build }.to add_method(method).to(klass)
    end
  end

  context 'when adding class methods' do
    subject(:builder) { builder_class.new(klass, method, value, class_method: true) }

    context 'when the builder runs' do
      it do
        expect { builder.build }.to add_class_method(method).to(klass)
      end
    end
  end
end
