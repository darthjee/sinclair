# frozen_string_literal: true

describe Sinclair::ConfigBuilder do
  subject(:builder) { described_class.new(config, config_attributes) }

  let(:config) { MyConfig.new }

  context 'when builder was configuratd with the method called' do
    let(:config_attributes) { [:name] }

    it 'sets the instance variable' do
      expect { builder.name 'John' }
        .to change(config, :name)
        .from(nil).to('John')
    end
  end

  context 'when builder was configuratd without the method called' do
    let(:config_attributes) { [] }

    it 'does not set the instance variable and raises error' do
      expect { builder.name 'John' }
        .to raise_error(NoMethodError)
        .and not_change(config, :name)
    end
  end

  context 'when using a variable name from builder variables' do
    let(:config_attributes) { [:config] }

    it 'sets the instance variable without changing builder instance variable' do
      expect { builder.config(key: 'value') }
        .to not_change { builder.instance_variable_get(:@config) }
        .and change(config, :config)
        .from(nil).to(key: 'value')
    end
  end
end
