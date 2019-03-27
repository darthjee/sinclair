# frozen_string_literal: true

describe Sinclair::MethodDefinition do
  describe 'yard' do
    describe '#build' do
      describe 'using string method with no options' do
        subject(:method_definition) do
          described_class.new(name, code)
        end

        let(:klass)    { Class.new }
        let(:instance) { klass.new }
        let(:code)     { '@x = @x.to_i ** 2 + 1' }
        let(:name)     { :sequence }

        it 'adds a dynamic method' do
          expect { method_definition.build(klass) }.to add_method(name).to(instance)
          expect(instance.sequence).to eq(1)
          expect(instance.sequence).to eq(2)
          expect(instance.sequence).to eq(5)
        end
      end

      describe 'using block with cache option' do
        subject(:method_definition) do
          described_class.new(name, cached: true) do
            @x = @x.to_i ** 2 + 1
          end
        end

        let(:klass)    { Class.new }
        let(:instance) { klass.new }
        let(:name)     { :sequence }

        it 'adds a dynamic method' do
          expect { method_definition.build(klass) }.to add_method(name).to(instance)
          expect { instance.sequence }.not_to change { instance.sequence }
          expect(instance.sequence).to eq(1)
        end
      end
    end
  end
end
