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

    context 'when initializing with custom config class that extends config_class' do
      subject(:factory) { described_class.new(config_class: MyConfig) }

      it do
        expect(factory.config).to be_a(MyConfig)
      end

      context 'when calling after reset_config' do
        before { factory.reset_config }

        it do
          expect(factory.config).to be_a(MyConfig)
        end
      end
    end

    context 'when initializing with custom config class that does not extend config_class' do
      subject(:factory) { described_class.new(config_class: DummyConfig) }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(described_class)
          .to receive(:warn)
      end
      # rubocop:enable RSpec/AnyInstance

      it do
        expect(factory.config).to be_a(DummyConfig)
      end

      it 'warns about class use' do
        factory.config

        expect(factory).to have_received(:warn)
          .with 'Config class is expected to be ConfigClass.' \
        'In future releases this will be enforced'
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
      subject(:factory) { described_class.new(config_class: MyConfig) }

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
    let(:config) { factory.config }

    let(:code_block) do
      proc { factory.instance_eval(&method_call) }
    end

    let(:setter_block) do
      proc { |value| factory.configure { name value } }
    end

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

    context 'when config class was set from common class' do
      subject(:factory) { described_class.new(config_class: config_class) }

      let(:config_class) { Class.new }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(described_class)
          .to receive(:warn)
      end
      # rubocop:enable RSpec/AnyInstance

      it_behaves_like 'a config factory adding config' do
        let(:method_call) { proc { add_configs(:name) } }

        it 'does not set a default value' do
          code_block.call

          expect(factory.config.name).to be_nil
        end

        it 'warns about class use' do
          code_block.call

          expect(factory).to have_received(:warn)
            .with 'Config class is expected to be ConfigClass.' \
          'In future releases this will be enforced'
        end
      end

      context 'when passing a hash' do
        it_behaves_like 'a config factory adding config' do
          let(:method_call) { proc { add_configs(name: 'Bobby') } }

          it 'sets a default value' do
            code_block.call

            expect(factory.config.name).to eq('Bobby')
          end

          it 'warns about class use' do
            code_block.call

            expect(factory).to have_received(:warn)
              .with 'Config class is expected to be ConfigClass.' \
            'In future releases this will be enforced'
          end
        end
      end
    end
  end

  describe '#configure' do
    context 'when factory was not initialized with defaults' do
      before { factory.add_configs(:user, 'password') }

      it_behaves_like 'configure a config'
    end

    context 'when factory initialized with defaults' do
      before do
        factory.add_configs(user: 'Jack', 'password' => 'abcdef')
      end

      it_behaves_like 'configure a config'
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
