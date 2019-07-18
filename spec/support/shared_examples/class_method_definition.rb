# frozen_string_literal: true

shared_examples 'ClassMethodDefinition#build' do
  it do
    expect { method_definition.build(klass) }
      .to add_class_method(method_name).to(klass)
  end

  describe 'after build' do
    before do
      method_definition.build(klass)
    end

    it 'adds the method to the klass' do
      expect(klass).to respond_to(method_name)
    end

    it 'evaluates return of the method within the klass context' do
      expect(klass.the_method).to eq(1)
    end

    it 'evaluates in the context of the klass' do
      expect { klass.the_method }
        .to change { klass.instance_variable_get(:@x) }
        .from(nil).to(1)
    end
  end
end

shared_examples 'ClassMethodDefinition#build without cache' do
  it_behaves_like 'ClassMethodDefinition#build'

  it 'creates a dynamic class method' do
    method_definition.build(klass)
    expect { klass.the_method }.to change(klass, :the_method)
      .from(1).to(3)
  end
end

shared_examples 'ClassMethodDefinition#build with cache' do
  it_behaves_like 'ClassMethodDefinition#build'

  it 'creates a semi-dynamic method' do
    method_definition.build(klass)
    expect { klass.the_method }.not_to change(klass, :the_method)
  end

  it 'sets the instance variable' do
    method_definition.build(klass)
    expect { klass.the_method }
      .to change { klass.instance_variable_get("@#{method_name}") }
      .from(nil).to(1)
  end
end

shared_examples 'ClassMethodDefinition#build with cache options' do
  context 'when cached is true' do
    let(:cached_option) { true }

    it_behaves_like 'ClassMethodDefinition#build with cache'

    context 'when instance variable has been set as nil' do
      before do
        method_definition.build(klass)
        klass.instance_variable_set(:@the_method, nil)
      end

      it 'returns a new value' do
        expect(klass.the_method).to eq(1)
      end
    end
  end

  context 'when cached is full' do
    let(:cached_option) { :full }

    it_behaves_like 'ClassMethodDefinition#build with cache'

    context 'when instance variable has been set as nil' do
      before do
        method_definition.build(klass)
        klass.instance_variable_set(:@the_method, nil)
      end

      it 'returns always nil' do
        expect(klass.the_method).to be_nil
      end
    end
  end

  context 'when cached is false' do
    let(:cached_option) { false }

    it_behaves_like 'ClassMethodDefinition#build without cache'
  end
end
