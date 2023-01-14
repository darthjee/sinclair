# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Writer do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, *attributes, type: type)
    end

    let(:klass)       { Class.new }
    let(:instance)    { klass.new }
    let(:value)       { Random.rand }
    let(:method_name) { :the_method }
    let(:attributes)  { [method_name] }

    context 'when type is instance' do
      let(:type) { Sinclair::MethodBuilder::INSTANCE_METHOD }

      it do
        expect { builder.build }
          .to add_method("#{method_name}=").to(instance)
      end

      context 'when the method is built' do
        let(:value) { Random.rand(10..20) }

        before do
          builder.build
        end

        it 'change the instance variable' do
          expect { instance.the_method = value }
            .to change { instance.instance_variable_get("@#{method_name}") }
            .from(nil).to(value)
        end
      end
    end

    context 'when type is class' do
      let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

      it do
        expect { builder.build }
          .to add_class_method("#{method_name}=").to(klass)
      end

      context 'when the method is built' do
        let(:value) { Random.rand(10..20) }

        before do
          builder.build
        end

        it 'change the instance variable' do
          expect { klass.the_method = value }
            .to change { klass.instance_variable_get("@#{method_name}") }
            .from(nil).to(value)
        end
      end
    end
  end
end
