# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::BlockHelper do
  subject(:helper) { described_class }

  let(:name)     { :method_name }
  let(:block)    { proc { RandomGenerator.rand } }
  let(:instance) { Class.new.new }

  describe '.cached_method_proc' do
    let(:method_block) do
      helper.cached_method_proc(name, &block)
    end

    it do
      expect(method_block).to be_a(Proc)
    end

    context 'when block is ran' do
      it 'returns the value from block' do
        expect(instance.instance_eval(&method_block))
          .to be_a(Numeric)
      end

      it 'cashes result of the call' do
        expect(instance.instance_eval(&method_block))
          .to eq(instance.instance_eval(&method_block))
      end

      it 'sets variable' do
        expect { instance.instance_eval(&method_block) }
          .to change { instance.instance_variable_get("@#{name}") }
          .from(nil)
      end

      context 'when instance has instance variable with value' do
        before do
          instance.instance_variable_set("@#{name}", Random.rand)
        end

        it 'does not change variable value' do
          expect { instance.instance_eval(&method_block) }
            .not_to change { instance.instance_variable_get("@#{name}") }
        end
      end

      context 'when instance has instance variable with nil' do
        before do
          instance.instance_variable_set("@#{name}", nil)
        end

        it 'changes variable value' do
          expect { instance.instance_eval(&method_block) }
            .to change { instance.instance_variable_get("@#{name}") }
        end
      end
    end
  end

  describe '.full_cached_method_proc' do
    let(:method_block) do
      helper.full_cached_method_proc(name, &block)
    end

    it do
      expect(method_block).to be_a(Proc)
    end

    context 'when block is ran' do
      it 'returns the value from block' do
        expect(instance.instance_eval(&method_block))
          .to be_a(Numeric)
      end

      it 'cashes result of the call' do
        expect(instance.instance_eval(&method_block))
          .to eq(instance.instance_eval(&method_block))
      end

      it 'sets variable' do
        expect { instance.instance_eval(&method_block) }
          .to change { instance.instance_variable_get("@#{name}") }
          .from(nil)
      end

      context 'when instance has instance variable with value' do
        before do
          instance.instance_variable_set("@#{name}", Random.rand)
        end

        it 'does not change variable value' do
          expect { instance.instance_eval(&method_block) }
            .not_to change { instance.instance_variable_get("@#{name}") }
        end
      end

      context 'when instance has instance variable with nil' do
        before do
          instance.instance_variable_set("@#{name}", nil)
        end

        it 'does not change variable value' do
          expect { instance.instance_eval(&method_block) }
            .not_to change { instance.instance_variable_get("@#{name}") }
        end
      end
    end
  end
end
