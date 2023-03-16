# frozen_string_literal: true

shared_examples 'sinclair model building' do
  context 'when the call happens with no options' do
    it 'Returns a new class' do
      expect(klass.superclass)
        .to eq(described_class)
    end

    it 'returns a class with getter' do
      expect(klass.instance_method(:name))
        .to be_a(UnboundMethod)
    end

    it 'returns a class with setter' do
      expect(klass.instance_method(:name=))
        .to be_a(UnboundMethod)
    end

    it 'returns a new class with a comparable that finds matches' do
      expect(model).to eq(klass.new(name: name))
    end

    it 'returns a new class with a comparable that find misses' do
      expect(model).not_to eq(klass.new(name: SecureRandom.hex(10)))
    end

    context 'when reader is called' do
      it do
        expect(model.name).to eq(name)
      end
    end

    context 'when setter is called' do
      let(:name)  { SecureRandom.hex(10) }
      let(:model) { klass.new(name: nil) }

      it do
        expect { model.name = name }
          .to change(model, :name)
          .from(nil)
          .to(name)
      end
    end
  end

  context 'when the call happens with comparable false' do
    let(:options) { { comparable: false } }

    it 'returns a new class without comparable' do
      expect(model).not_to eq(klass.new(name: name))
    end
  end

  context 'when the call happens with reader options' do
    let(:options) { { writter: false } }

    it 'Returns a new class' do
      expect(klass.superclass)
        .to eq(described_class)
    end

    it 'returns a class with getter' do
      expect(klass.instance_method(:name))
        .to be_a(UnboundMethod)
    end

    it 'returns a class without setter' do
      expect { klass.instance_method(:name=) }
        .to raise_error(NameError)
    end

    context 'when reader is called' do
      it do
        expect(model.name).to eq(name)
      end
    end
  end

  context 'when the call happens with defaults' do
    let(:attributes) { [{ name: 'John Doe' }] }

    it 'Returns a new class' do
      expect(klass.superclass)
        .to eq(described_class)
    end

    it 'returns a class with getter' do
      expect(klass.instance_method(:name))
        .to be_a(UnboundMethod)
    end

    it 'returns a class with setter' do
      expect(klass.instance_method(:name=))
        .to be_a(UnboundMethod)
    end

    context 'when reader is called' do
      subject(:model) { klass.new }

      let(:name) { SecureRandom.hex(10) }

      it 'returns the dfault value' do
        expect(model.name).to eq('John Doe')
      end
    end

    context 'when setter is called' do
      subject(:model) { klass.new }

      let(:name) { SecureRandom.hex(10) }

      it do
        expect { model.name = name }
          .to change(model, :name)
          .from('John Doe')
          .to(name)
      end
    end
  end
end
