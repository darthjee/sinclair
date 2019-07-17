# frozen_string_literal: true

describe Sinclair::MethodDefinition::InstanceStringDefinition do
  describe 'yard' do
    describe '#build' do
      subject(:method_definition) do
        described_class.new(name, code)
      end

      let(:klass)    { Class.new }
      let(:instance) { klass.new }
      let(:code)     { '@x = @x.to_i ** 2 + 1' }
      let(:name)     { :sequence }

      it 'adds a dynamic method' do
        expect { method_definition.build(klass) }.to add_method(name).to(instance)
        expect { instance.sequence }
          .to change { instance.instance_variable_get(:@x) }.from(nil).to 1
        expect(instance.sequence).to eq(2)
        expect(instance.sequence).to eq(5)
      end

      it 'changes instance variable' do
        method_definition.build(klass)

        expect { instance.sequence }
          .to change { instance.instance_variable_get(:@x) }
          .from(nil).to 1
      end
    end
  end
end
