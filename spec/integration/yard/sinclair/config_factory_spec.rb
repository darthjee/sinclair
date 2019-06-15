# frozen_string_literal: true

describe Sinclair::ConfigFactory do
  describe '#yard' do
    subject(:factory) do
      described_class.new(
        config_class: config_class,
        config_attributes: config_attributes
      )
    end

    let(:config_class)      { Class.new(Sinclair::Config) }
    let(:config_attributes) { [:name] }
    let(:config)            { factory.config }

    describe 'general usage' do
      context 'when not passing any argument' do
        subject(:factory) { described_class.new }

        before do
          factory.add_configs(:name)
          factory.configure { |c| c.name 'John' }
        end

        it 'returns an instance of Config child class' do
          expect(config.class.superclass)
            .to eq(Sinclair::Config)
        end

        it 'configures name to be John' do
          expect(config.name).to eq('John')
        end

        it 'returns always the same instance' do
          expect(factory.config).to be_equal(config)
        end
      end
    end

    describe '#reset_config' do
      it 'changes config instance' do
        expect { factory.reset_config }
          .to change(factory, :config)
      end
    end

    describe '#add_configs' do
      let(:config) { factory.config }

      context 'when it already have config_attributes' do
        it 'returns current possible configurations' do
          expect(factory.add_configs('active'))
            .to eq(%i[name active])
        end
      end

      context 'when initializing with no parameters' do
        subject(:factory) { described_class.new }

        it 'adds method to config' do
          expect { factory.add_configs(:active) }
            .to change { config.respond_to?(:active) }
            .from(false).to(true)
        end
      end
    end

    describe '#configure' do
      let(:config_class) { MyConfig }

      it 'sets variable on config' do
        expect { factory.configure { name 'John' } }
          .to change(config, :name)
          .from(nil).to('John')
      end
    end
  end
end
