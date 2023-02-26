# frozen_string_literal: true

RSpec.shared_examples "A builder extension" do
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
