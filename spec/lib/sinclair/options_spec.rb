# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options do
  subject(:options) { klass.new }

  let(:klass) { Class.new(described_class) }

  describe '.with_options' do
    context 'when calling with keys' do
      it 'add first method' do
        expect { klass.send(:with_options, :timeout, :retries) }
          .to add_method(:timeout).to(klass)
      end

      it 'add second method' do
        expect { klass.send(:with_options, :timeout, :retries) }
          .to add_method(:retries).to(klass)
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, :timeout, :retries) }

        it { expect(options.timeout).to be_nil }
      end
    end

    context 'when calling with a hash' do
      it 'adds method' do
        expect { klass.send(:with_options, timeout: 10) }
          .to add_method(:timeout).to(klass)
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, timeout: 10) }

        it { expect(options.timeout).not_to be_nil }
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
