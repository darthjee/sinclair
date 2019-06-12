# frozen_string_literal: true

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

    context 'when calling after reset' do
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
    it do
      expect { configurable.send(:configurable_with, :name) }
        .to add_method(:name).to(configurable.config)
    end

    it 'does not change parent class configuration' do
      expect { configurable.send(:configurable_with, :name) }
        .not_to add_method(:name).to(DummyConfigurable.config)
    end

    it 'does not change Sinclair::Config' do
      expect { configurable.send(:configurable_with, :name) }
        .not_to add_method(:name).to(Sinclair::Config.new)
    end

    it 'does not mess with configurable methods' do
      configurable.send(:configurable_with, :reset)
      configurable.configure { |c| c.reset true }
      configurable.reset
      expect(configurable.config).to be_a(Sinclair::Config)
    end
  end

  describe '.configure' do
    let(:config) { configurable.config }

    it do
      expect { configurable.configure { |c| c.user 'Bob' } }
        .to change(config, :user)
        .from(nil).to('Bob')
    end

    context 'when it was defined using string' do
      it do
        expect { configurable.configure { |c| c.password '123456' } }
          .to change(config, :password)
          .from(nil).to('123456')
      end
    end

    context 'when calling a method that was not defined' do
      it do
        expect { configurable.configure { |c| c.nope '123456' } }
          .to raise_error(NoMethodError)
      end
    end
  end
end
