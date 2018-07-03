require 'spec_helper'

RSpec.describe DefaultValue do
  let(:klass)    { Class.new }
  let(:method)   { :the_method }
  let(:value)    { Random.rand(100) }
  let(:builder)  { described_class.new(klass, method, value) }
  let(:instance) { klass.new }

  context 'when the builder runs' do
    it do
      expect do
        described_class.new(klass, method, value).build
      end.to add_method(method).to(instance)
    end
  end

  context 'when the builder runs' do
    it do
      expect do
        described_class.new(klass, method, value).build
      end.to add_method(method).to(klass)
    end
  end
end
