# frozen_string_literal: true

shared_examples 'MethodDefinition#build' do
  it do
    expect { method_definition.build(klass) }.to add_method(method_name).to(klass)
  end

  describe 'after build' do
    before do
      method_definition.build(klass)
    end

    it 'adds the method to the klass instance' do
      expect(instance).to respond_to(method_name)
    end

    it 'evaluates return of the method within the instance context' do
      expect(instance.the_method).to eq(1)
    end

    it 'evaluates in the context of the instance' do
      expect { instance.the_method }
        .to change { instance.instance_variable_get(:@x) }
        .from(nil).to(1)
    end
  end
end

shared_examples 'MethodDefinition#build without cache' do
  it_behaves_like 'MethodDefinition#build'

  it 'creates a dynamic method' do
    method_definition.build(klass)
    expect { instance.the_method }.to change(instance, :the_method)
      .from(1).to(3)
  end
end

shared_examples 'MethodDefinition#build with cache' do
  it_behaves_like 'MethodDefinition#build'

  it 'creates a semi-dynamic method' do
    method_definition.build(klass)
    expect { instance.the_method }.not_to change(instance, :the_method)
  end

  it 'sets the instance variable' do
    method_definition.build(klass)
    expect { instance.the_method }
      .to change { instance.instance_variable_get("@#{method_name}") }
      .from(nil).to(1)
  end
end
