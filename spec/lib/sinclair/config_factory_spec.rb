require 'spec_helper'

describe Sinclair::ConfigFactory do
  subject(:factory) { described_class.new }

  let(:config) { factory.config }

  describe '#config' do
    it do
      expect(factory.config).to be_a(Sinclair::Config)
    end

    context 'when calling twice' do
      it 'returns the same instance' do
        expect(factory.config)
          .to be(factory.config)
      end
    end

    context 'after reset' do
      before { factory.reset }

      it do
        expect(factory.config).to be_a(Sinclair::Config)
      end
    end
  end

  describe '#reset' do
    let(:old_instance) { factory.config }

    it 'resets instance' do
      expect { factory.reset }
        .to change { factory.config.eql?(old_instance) }
        .from(true).to(false)
    end

    it 'forces regeneration of instance' do
      expect { factory.reset }
        .not_to change { factory.config.class }
    end
  end

  describe '#add_configs' do
    it do
      expect { factory.add_configs(:name) }
        .to add_method(:name).to(factory.config)
    end

    it 'does not change Sinclair::Config class' do
      expect { factory.add_configs(:name) }
        .not_to add_method(:name).to(Sinclair::Config.new)
    end

    xit 'changes subclasses of config' do
    end
  end

  describe '#configure' do
    before { factory.add_configs(:user) }

    it do
      expect { factory.configure { |c| c.user 'Bob' } }
        .to change(config, :user)
        .from(nil).to('Bob')
    end
  end
end
