# frozen_string_literal: true

shared_examples 'a config factory adding config' do
  let(:code_block) do
    proc { factory.instance_eval(&method_call) }
  end

  it 'adds reader to config' do
    expect(&code_block).to add_method(:name).to(factory.config)
  end

  it 'does not add setter to config' do
    expect(&code_block)
      .not_to add_method(:name=).to(factory.config)
  end

  it 'does not change Sinclair::Config class' do
    expect(&code_block)
      .not_to add_method(:name).to(Sinclair::Config.new)
  end

  it 'allows config_builder to handle method missing' do
    code_block.call

    expect { factory.configure { name 'John' } }
      .not_to raise_error
  end

  it 'adds reader for configuration' do
    code_block.call
    factory.configure { name 'John' }

    expect(factory.config.name).to eq('John')
  end

  it 'changes subclasses of config' do
    expect(&code_block)
      .to add_method(:name).to(factory.child.config)
  end

  it 'does not mess with parent config_builder' do
    factory.child.instance_eval(&method_call)
    expect { factory.configure { name 'John' } }
      .to raise_error(NoMethodError)
  end

  context 'when initializing with custom config class' do
    it do
      expect(&code_block)
        .to add_method(:name).to(factory.config)
    end

    it 'does not change other config classes' do
      expect(&code_block)
        .not_to add_method(:name).to(other_factory.config)
    end
  end
end
