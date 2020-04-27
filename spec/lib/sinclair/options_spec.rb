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
    context 'when initializing with no args' do
      it do
        expect { klass.new }.not_to raise_error
      end
    end
  end
end
