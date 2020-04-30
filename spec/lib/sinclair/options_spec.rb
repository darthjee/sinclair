# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options do
  subject(:options) { klass.new }

  describe '.with_options' do
    let(:klass) { Class.new(described_class) }

    context 'when calling with keys' do
      it 'add first method' do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to add_method(:timeout).to(klass)
      end

      it 'add second method' do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to add_method(:retries).to(klass)
      end

      it do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to change(klass, :allowed_options)
          .from([])
          .to(%i[timeout retries])
      end

      it do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .not_to change(described_class, :allowed_options)
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, :timeout, 'retries') }

        it { expect(options.timeout).to be_nil }
      end
    end

    context 'when calling with a hash' do
      it 'adds method' do
        expect { klass.send(:with_options, timeout_sec: 10, 'retries' => 20) }
          .to add_method(:timeout_sec).to(klass)
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, timeout_sec: 10, 'retries' => 20) }

        it 'returns default value' do
          expect(options.retries).to eq(20)
        end
      end
    end

    context 'when calling on subclass' do
      let(:super_class) { Class.new(described_class) }
      let(:klass)       { Class.new(super_class) }

      before { super_class.send(:with_options, :timeout, 'retries') }

      it 'add first method' do
        expect { klass.send(:with_options, :protocol, 'port' => 443) }
          .to add_method(:protocol).to(klass)
      end

      it 'add second method' do
        expect { klass.send(:with_options, :protocol, 'port' => 443) }
          .to add_method(:port).to(klass)
      end

      it do
        expect { klass.send(:with_options, 'protocol', port: 443) }
          .to change(klass, :allowed_options)
          .from(%i[timeout retries])
          .to(%i[timeout retries protocol port])
      end

      it do
        expect { klass.send(:with_options, 'protocol', port: 443) }
          .not_to change(super_class, :allowed_options)
      end
    end
  end

  describe '#initialize' do
    let(:klass) { ConnectionOptions }

    context 'when initializing with no args' do
      it do
        expect { klass.new }.not_to raise_error
      end

      it 'initializes methods with default values' do
        expect(options.port).to eq(443)
      end
    end

    context 'when initializing with valid args' do
      subject(:options) do
        klass.new(timeout: timeout, protocol: 'http')
      end

      let(:timeout) { Random.rand(10..19) }

      it 'sets value of options attribute' do
        expect(options.timeout).to eq(timeout)
      end

      it 'sets value of options attribute that has default' do
        expect(options.protocol).to eq('http')
      end

      it 'does not mess with non initialized attributes' do
        expect(options.retries).to be_nil
      end

      it 'does not mess with non initialized attributes with defaults' do
        expect(options.port).to eq(443)
      end
    end

    context 'when initializing subclass with valid args' do
      subject(:options) do
        klass.new(timeout: timeout, protocol: 'http')
      end

      let(:klass)   { Class.new(ConnectionOptions) }
      let(:timeout) { Random.rand(10..19) }

      before do
        klass.send(:with_options, :access_token, identifier: 'my client')
      end

      it 'sets value of options attribute' do
        expect(options.timeout).to eq(timeout)
      end

      it 'sets value of options attribute that has default' do
        expect(options.protocol).to eq('http')
      end

      it 'does not mess with non initialized attributes' do
        expect(options.retries).to be_nil
      end

      it 'does not mess with non initialized attributes with defaults' do
        expect(options.port).to eq(443)
      end

      it 'returns nil for new added option without default' do
        expect(options.access_token).to be_nil
      end

      it 'returns value for new added option with default' do
        expect(options.identifier).to eq('my client')
      end
    end

    context 'when initializing with invalid args' do
      it do
        expect { klass.new(invalid: 10) }
          .to raise_error(Sinclair::Exception::InvalidOptions)
      end
    end

    context 'when initializing with string or symbol keys' do
      it do
        expect { klass.new('timeout' => 20, retries: 30) }
          .not_to raise_error
      end
    end
  end
end
