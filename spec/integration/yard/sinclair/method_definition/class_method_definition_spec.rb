# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ClassMethodDefinition do
  describe 'yard' do
    describe '#build' do
      describe 'using string method with no options' do
        subject(:method_definition) do
          described_class.from(name, code)
        end

        let(:klass)    { Class.new }
        let(:code)     { '@x = @x.to_i ** 2 + 1' }
        let(:name)     { :sequence }

        it 'adds a dynamic method' do
          expect { method_definition.build(klass) }.to add_class_method(name).to(klass)
          expect { klass.sequence }
            .to change { klass.instance_variable_get(:@x) }.from(nil).to 1
          expect(klass.sequence).to eq(2)
          expect(klass.sequence).to eq(5)
        end

        it 'changes klass variable' do
          method_definition.build(klass)

          expect { klass.sequence }
            .to change { klass.instance_variable_get(:@x) }
            .from(nil).to 1
        end
      end

      describe 'using block with cache option' do
        subject(:method_definition) do
          described_class.from(name, cached: true) do
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
