require 'spec_helper'

describe Sinclair::MethodDefinition do
  let(:clazz) { Class.new }
  let(:instance) { clazz.new }

  describe '#build' do
    let(:method_name) { :the_method }

    context 'when method was defined with an string' do
      let(:code) { '"Self ==> " + self.to_s' }

      subject { described_class.new(method_name, code) }

      before do
        subject.build(clazz)
      end

      it 'adds the method to the clazz instance' do
        expect(instance).to respond_to(method_name)
      end

      it 'evaluates return of the method within the instance context' do
        expect(instance.the_method).to eq("Self ==> #{instance}")
      end
    end

    context 'when method was defined with a block' do
      subject do
        described_class.new(method_name) do
          "Self ==> " + self.to_s
         end
      end

      before do
        subject.build(clazz)
      end

      it 'adds the method to the clazz instance' do
        expect(instance).to respond_to(method_name)
      end

      it 'evaluates return of the method within the instance context' do
        expect(instance.the_method).to eq("Self ==> #{instance}")
      end
    end
  end
end
