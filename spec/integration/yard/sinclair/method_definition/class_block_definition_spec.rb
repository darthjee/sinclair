# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ClassBlockDefinition do
  describe 'yard' do
    describe '#build' do
      subject(:method_definition) do
        described_class.new(name) do
          @x = @x.to_i**2 + 1
        end
      end

      let(:klass)    { Class.new }
      let(:name)     { :sequence }

      it 'adds a dynamic method' do
        expect { method_definition.build(klass) }.to add_class_method(name).to(klass)
        expect { klass.sequence }
          .to change { klass.instance_variable_get(:@x) }.from(nil).to 1
        expect(klass.sequence).to eq(2)
        expect(klass.sequence).to eq(5)
      end

      it 'changes instance variable' do
        method_definition.build(klass)

        expect { klass.sequence }
          .to change { klass.instance_variable_get(:@x) }
          .from(nil).to 1
      end
    end
  end
end
