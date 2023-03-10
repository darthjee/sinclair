# frozen_string_literal: true

RSpec.shared_examples 'A sinclair builder' do |type|
  let(:method_name) do
    type == :instance ? :add_method : :add_class_method
  end

  context 'when extending the builder' do
    let(:builder_class) do
      type == :instance ? described_class::DummyBuilder : described_class::DummyClassBuilder
    end

    before do
      builder.init
      builder.build
    end

    context 'when describing a method with block' do
      it 'creates a method with the block' do
        expect(object.blocked).to eq(1)
      end
    end

    context 'when describing a method with string' do
      it 'creates a method using the string definition' do
        expect(object.defined).to eq(1)
        expect(object.defined).to eq(2)
      end
    end

    context 'when describing a method with string' do
      it 'creates a method using the string definition' do
        expect(object.sum(10, 23)).to eq(33)
      end
    end

    context 'when describing a method using a block specific type' do
      it 'creates a method with the block' do
        expect(object.type_block).to eq(3)
      end
    end

    context 'when describing a method using a string specific type' do
      it 'creates a method with the string' do
        expect(object.type_string).to eq(10)
      end
    end

    context 'when describing a method using a call specific type for attr_acessor' do
      let(:value) { Random.rand }

      it 'creates acessors' do
        expect { object.some_attribute = value }
          .to change(object, :some_attribute)
          .from(nil).to(value)
      end
    end

    context 'when passing options' do
      let(:options) { { increment: 2 } }

      it 'parses the options' do
        expect(object.defined).to eq(2)
        expect(object.defined).to eq(4)
      end
    end
  end

  context 'when adding methods to a regular builder' do
    context 'when declaring a method with a block' do
      before do
        builder.public_send(method_name, :blocked) { 1 }
        builder.public_send(method_name, :blocked) { 2 }
        builder.build
      end

      it 'respect the order of method addtion' do
        expect(object.blocked).to eq(2)
      end
    end

    context 'when declaring a method string' do
      before do
        builder.public_send(method_name, :string, '1')
        builder.public_send(method_name, :string, '2')
        builder.build
      end

      it 'respect the order of method addtion' do
        expect(object.string).to eq(2)
      end
    end

    context 'when declaring block and string' do
      before do
        builder.public_send(method_name, :value) { 1 }
        builder.public_send(method_name, :value, '2')
        builder.build
      end

      it 'respect the order of method addtion' do
        expect(object.value).to eq(2)
      end
    end

    context 'when declaring string and block' do
      before do
        builder.public_send(method_name, :value, '1')
        builder.public_send(method_name, :value) { 2 }
        builder.build
      end

      it 'respect the order of method addtion' do
        expect(object.value).to eq(2)
      end
    end
  end
end
