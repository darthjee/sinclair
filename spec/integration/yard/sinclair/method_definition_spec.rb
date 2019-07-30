# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition do
  describe 'yard' do
    describe '#build' do
      describe 'using block with cache option' do
        subject(:method_definition) do
          described_class::ClassMethodDefinition.from(name, cached: true) do
            @x = @x.to_i**2 + 1
          end
        end

        let(:klass)    { Class.new }
        let(:name)     { :sequence }

        it 'adds a dynamic method' do
          expect { method_definition.build(klass) }.to add_class_method(name).to(klass)
          expect { klass.sequence }
            .to change { klass.instance_variable_get(:@x) }.from(nil).to 1
          expect { klass.sequence }.not_to change(klass, :sequence)
          expect(klass.instance_variable_get(:@sequence)).to eq(1)
        end
      end
    end
  end
end
