# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigFactory do
  subject(:factory) { described_class.new }

  let(:config)        { factory.config }
  let(:other_factory) { described_class.new }

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

    context 'when calling after reset_config' do
      before { factory.reset_config }

      it do
        expect(factory.config).to be_a(Sinclair::Config)
      end
    end

    context 'when initializing with custom config class' do
      subject(:factory) { described_class.new(config_class: DummyConfig) }

      it do
        expect(factory.config).to be_a(DummyConfig)
      end

      context 'when calling after reset_config' do
        before { factory.reset_config }

        it do
          expect(factory.config).to be_a(DummyConfig)
        end
      end
    end
  end

  describe '#reset_config' do
    let(:old_instance) { factory.config }

    it 'reset_configs instance' do
      expect { factory.reset_config }
        .to change { factory.config.eql?(old_instance) }
        .from(true).to(false)
    end

    it 'forces regeneration of instance' do
      expect { factory.reset_config }
        .not_to change { factory.config.class }
    end

    context 'when initializing with custom config class' do
      subject(:factory) { described_class.new(config_class: DummyConfig) }

      it 'reset_configs instance' do
        expect { factory.reset_config }
          .to change { factory.config.eql?(old_instance) }
          .from(true).to(false)
      end

      it 'forces regeneration of instance' do
        expect { factory.reset_config }
          .not_to change { factory.config.class }
      end

      it 'does not affect other factories' do
        expect { factory.reset_config }
          .not_to change(other_factory, :config)
      end
    end
  end

  describe '#add_configs' do
    it_behaves_like 'a config factory adding config' do
      let(:method_call) { proc { add_configs(:name) } }

      it 'does not set a default value' do
        code_block.call

        expect(factory.config.name).to be_nil
      end
    end

    it 'does not mess with configurable methods' do
      factory.add_configs(:reset_config)
      factory.configure { |c| c.reset_config true }
      factory.reset_config
      expect(factory.config).to be_a(Sinclair::Config)
    end

    context 'when passing a hash' do
      it_behaves_like 'a config factory adding config' do
        let(:method_call) { proc { add_configs(name: 'Bobby') } }

        it 'sets a default value' do
          code_block.call

          expect(factory.config.name).to eq('Bobby')
        end
      end
    end
  end

  describe '#configure' do
    before { factory.add_configs(:user, 'password') }

    it do
      expect { factory.configure { |c| c.user 'Bob' } }
        .to change(config, :user)
        .from(nil).to('Bob')
    end

    context 'when it was defined using string' do
      it do
        expect { factory.configure { |c| c.password '123456' } }
          .to change(config, :password)
          .from(nil).to('123456')
      end
    end

    context 'when calling a method that was not defined' do
      it do
        expect { factory.configure { |c| c.nope '123456' } }
          .to raise_error(NoMethodError)
      end
    end
  end

  describe '#child' do
    it { expect(factory.child).to be_a(described_class) }

    it 'generates factory capable of generating config subclasses' do
      expect(factory.child.config).to be_a(factory.config.class)
    end

    it 'generates factory that does not generate same config class' do
      expect(factory.child.config.class).not_to eq(factory.config.class)
    end
  end
end
