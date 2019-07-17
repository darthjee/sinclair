# frozen_string_literal: true

describe Sinclair::MethodDefinition::InstanceBlockDefinition do
  describe 'yard' do
    describe '#build' do
      subject(:method_definition) do
        described_class.from(name, cached: true) do
          @x = @x.to_i**2 + 1
        end
      end

      let(:klass)    { Class.new }
      let(:instance) { klass.new }
      let(:name)     { :sequence }

      it 'adds a dynamic method' do
        expect { method_definition.build(klass) }.to add_method(name).to(instance)
        expect { instance.sequence }
          .to change { instance.instance_variable_get(:@x) }.from(nil).to(1)
        expect { instance.sequence }.not_to change(instance, :sequence)
        expect(instance.instance_variable_get(:@sequence)).to eq(1)
      end
    end
  end
end
