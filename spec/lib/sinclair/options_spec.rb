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
    end
  end

  describe '#initialize' do
    let(:klass) { ConnectionOptions }

    context 'when initializing with no args' do
      it do
        expect { klass.new }.not_to raise_error
      end
    end

    context 'when initializing with valid args' do
      subject(:options) { klass.new(timeout: timeout) }

      let(:timeout) { 10 + Random.rand(10) }

      it 'sets value of options attribute' do
        expect(options.timeout).to eq(timeout)
      end
    end
    
    context 'when initializing with valid args' do
      it do
        expect { klass.new(invalid: 10) }
          .to raise_error(Sinclair::Exception::InvalidOptions)
      end
    end
  end
end
