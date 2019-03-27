# frozen_string_literal: true

require 'spec_helper'

shared_examples 'MethodDefinition#build' do
  it do
    expect { method_definition.build(klass) }.to add_method(method_name).to(klass)
  end

  describe 'after build' do
    before do
      method_definition.build(klass)
    end

    it 'adds the method to the klass instance' do
      expect(instance).to respond_to(method_name)
    end

    it 'evaluates return of the method within the instance context' do
      expect(instance.the_method).to eq("Self ==> #{instance}")
    end
  end
end

describe Sinclair::MethodDefinition do
  let(:klass) { Class.new }
  let(:instance) { klass.new }

  describe '#build' do
    let(:method_name) { :the_method }

    context 'when method was defined with an string' do
      let(:code) { '"Self ==> " + self.to_s' }

      subject(:method_definition) do
        described_class.new(method_name, code)
      end

      it_behaves_like 'MethodDefinition#build'
    end

    context 'when method was defined with a block' do
      subject(:method_definition) do
        described_class.new(method_name) do
          'Self ==> ' + to_s
        end
      end

      it_behaves_like 'MethodDefinition#build'
    end
  end
end
