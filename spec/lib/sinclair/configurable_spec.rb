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

    context 'when calling after reset_config' do
      before { configurable.reset_config }

      it do
        expect(configurable.config).to be_a(Sinclair::Config)
      end
    end
  end

  describe '.reset_config' do
    let(:old_instance) { configurable.config }

    it 'reset_configs instance' do
      expect { configurable.reset_config }
        .to change { configurable.config.eql?(old_instance) }
        .from(true).to(false)
    end

    it 'forces regeneration of instance' do
      expect { configurable.reset_config }
        .not_to change { configurable.config.class }
    end
  end

  describe '.configurable_with' do
    it do
      expect(configurable.send(:configurable_with, :name, 'host'))
        .to all(be_a(Symbol))
    end

    it 'adds reader to config' do
      expect { configurable.send(:configurable_with, :name) }
        .to add_method(:name).to(configurable.config)
    end

    it 'does not add setter to config' do
      expect { configurable.send(:configurable_with, :name) }
        .not_to add_method(:name=).to(configurable.config)
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
      configurable.send(:configurable_with, :reset_config)
      configurable.configure { |c| c.reset_config true }
      configurable.reset_config
      expect(configurable.config).to be_a(Sinclair::Config)
    end

    context 'when configurable is a module' do
      subject(:configurable) do
        Module.new { extend Sinclair::Configurable }
      end

      it do
        expect { configurable.send(:configurable_with, :name) }
          .not_to raise_error
      end

      it 'adds reader to config' do
        expect { configurable.send(:configurable_with, :name) }
          .to add_method(:name).to(configurable.config)
      end
    end
  end

  describe '#configurable_by' do
    let(:config_class) { ServerConfig }

    it do
      expect(configurable.send(:configurable_by, config_class))
        .to be_a(Sinclair::ConfigFactory)
    end

    it 'changes config class' do
      expect { configurable.send(:configurable_by, config_class) }
        .to change { configurable.config.class }
        .to(ServerConfig)
    end

    context 'when config attributes are not given' do
      it 'raises error with any configuration' do
        expect { configurable.configure { host 'myhost' } }
          .to raise_error(NoMethodError)
      end
    end

    context 'when config attributes are given' do
      let(:attributes) { [:host, 'port'] }

      let(:block) do
        proc do
          configurable.send(
            :configurable_by, config_class, with: attributes
          )
        end
      end

      # rubocop:disable RSpec/SubjectStub
      before do
        allow(configurable)
          .to receive(:warn)
          .with(described_class::CONFIG_CLASS_WARNING)
      end
      # rubocop:enable RSpec/SubjectStub

      it 'does not add symbol methods config object' do
        expect(&block)
          .not_to add_method(:host).to(configurable.config)
      end

      it 'does not add string methods config object' do
        expect(&block)
          .not_to add_method(:port).to(configurable.config)
      end

      # rubocop:disable RSpec/SubjectStub
      it 'sends deprecation warning' do
        block.call
        expect(configurable).to have_received(:warn)
      end
      # rubocop:enable RSpec/SubjectStub

      it 'does not raises error on configuration of given symbol attributes' do
        block.call

        expect { configurable.configure { host 'myhost' } }
          .not_to raise_error
      end

      it 'does not raises error on configuration of given string attributes' do
        block.call

        expect { configurable.configure { port 90 } }
          .not_to raise_error
      end
    end
  end

  describe '.configure' do
    let(:config) { configurable.config }

    context 'when configuring using a block' do
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

    context 'when configuring using a hash' do
      it do
        expect { configurable.configure(user: 'Bob') }
          .to change(config, :user)
          .from(nil).to('Bob')
      end

      context 'when it was defined using string' do
        it do
          expect { configurable.configure(password: '123456') }
            .to change(config, :password)
            .from(nil).to('123456')
        end
      end

      context 'when calling a method that was not defined' do
        it do
          expect { configurable.configure(nope: '123456') }
            .to raise_error(NoMethodError)
        end
      end
    end

    context 'when it was configured by custom class' do
      let(:config_class) { ServerConfig }

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(configurable)
          .to receive(:warn)
          .with(described_class::CONFIG_CLASS_WARNING)
        # rubocop:enable RSpec/SubjectStub

        configurable.send(
          :configurable_by, config_class, with: [:host, 'port']
        )
      end

      context 'when config class has the methods' do
        it do
          expect { configurable.configure { |c| c.host 'myhost' } }
            .not_to raise_error
        end

        it 'sets variable' do
          expect { configurable.configure { |c| c.host 'myhost' } }
            .to change(config, :host)
            .from(nil).to('myhost')
        end
      end

      context 'when config class does not have the methods' do
        let(:config_class) { Class.new(Sinclair::Config) }

        it do
          expect { configurable.configure { |c| c.host 'myhost' } }
            .not_to raise_error
        end

        it 'sets variable' do
          expect { configurable.configure { |c| c.host 'myhost' } }
            .to change { config.instance_variable_get(:@host) }
            .from(nil).to('myhost')
        end
      end
    end
  end
end
