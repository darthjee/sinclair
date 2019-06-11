require 'spec_helper'

describe Sinclair::Configurable do
  subject(:configurable) { Class.new(DummyConfigurable) }

  describe '.config' do
    it do
      expect(configurable.config).to be_a(Sinclair::Config)
    end

    context 'when calling twice' do
      it 'returns the same instance' do
        expect(configurable.config)
          .to be(configurable.config)
      end
    end

    context 'after reset' do
      before { configurable.reset }

      it do
        expect(configurable.config).to be_a(Sinclair::Config)
      end
    end
  end

  describe '.reset' do
    let(:old_instance) { configurable.config }

    it 'resets instance' do
      expect { configurable.reset }
        .to change { configurable.config.eql?(old_instance) }
        .from(true).to(false)
    end

    it 'forces regeneration of instance' do
      expect { configurable.reset }
        .not_to change { configurable.config.class }
    end
  end

  describe '.configurable_with' do
    it 'adds method to config' do
      expect { configurable.send(:configurable_with, :name) }
        .to change { configurable.config.respond_to?(:name) }
        .from(false).to(true)
    end

    it 'does not change parent class configuration' do
      expect { configurable.send(:configurable_with, :name) }
        .not_to change { DummyConfigurable.config.respond_to?(:name) }
    end

    it 'does not change Sinclair::Config' do
      expect { configurable.send(:configurable_with, :name) }
        .not_to change { Sinclair::Config.new.respond_to?(:name) }
    end
  end
end
