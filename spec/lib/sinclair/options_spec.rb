# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options do
  subject(:options) { klass.new }

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
        klass.new(timeout:, protocol: 'http')
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
        klass.new(timeout:, protocol: 'http')
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

    context 'when initializing with invalid args a class that skips validation' do
      let(:klass) { OpenOptions }

      it do
        expect { klass.new(valid_option: 20, invalid: 10) }
          .not_to raise_error
      end

      it 'initialize option' do
        expect(klass.new(valid_option: 20, invalid: 10).valid_option)
          .to eq(20)
      end

      context 'when initializing a subclass' do
        let(:klass) { Class.new(OpenOptions) }

        it do
          expect { klass.new(valid_option: 20, invalid: 10) }
            .not_to raise_error
        end

        it 'initialize option' do
          expect(klass.new(valid_option: 20, invalid: 10).valid_option)
            .to eq(20)
        end
      end
    end

    context 'when initializing with string or symbol keys' do
      it do
        expect { klass.new('timeout' => 20, retries: 30) }
          .not_to raise_error
      end

      context 'when calling the method' do
        let(:options) { klass.new('timeout' => 20, retries: 30) }

        it 'sets value of string key' do
          expect(options.timeout).to eq(20)
        end

        it 'sets value of symbol key' do
          expect(options.retries).to eq(30)
        end
      end
    end

    context 'when overriding values with nil' do
      let(:options) { klass.new(protocol: nil) }

      it { expect(options.protocol).to be_nil }
    end

    context 'when overriding values with false' do
      let(:options) { klass.new(protocol: false) }

      it { expect(options.protocol).to be(false) }
    end
  end

  describe '#to_h' do
    let(:klass) { Class.new(described_class) }

    context 'without defined options' do
      it { expect(options.to_h).to be_a(Hash) }

      it { expect(options.to_h).to be_empty }
    end

    context 'with defined options' do
      before do
        klass.send(:with_options, :timeout, retries: 10, 'protocol' => 'https')
      end

      it { expect(options.to_h).to be_a(Hash) }

      it { expect(options.to_h).not_to be_empty }

      it do
        expect(options.to_h)
          .to eq(timeout: nil, retries: 10, protocol: 'https')
      end

      context 'when initialized with values' do
        subject(:options) { klass.new(retries: 20, timeout: 5) }

        it { expect(options.to_h).to be_a(Hash) }

        it { expect(options.to_h).not_to be_empty }

        it 'uses values from initialization' do
          expect(options.to_h)
            .to eq(timeout: 5, retries: 20, protocol: 'https')
        end
      end
    end
  end

  describe '#==' do
    let(:klass) { ConnectionOptions }

    context 'with black initialization' do
      it do
        expect(klass.new).to eq(klass.new)
      end
    end

    context 'when initializing with same values' do
      let(:first_option)  { klass.new(protocol: nil) }
      let(:second_option) { klass.new(protocol: nil) }

      it { expect(first_option).to eq(second_option) }
    end

    context 'when initializing with different values' do
      let(:first_option) { klass.new(protocol: nil) }
      let(:second_option) { klass.new }

      it { expect(first_option).not_to eq(second_option) }
    end
  end
end
