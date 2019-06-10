require 'spec_helper'

describe Sinclair::Configurable do
  subject(:configurable) { DummyConfigurable }

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
end
