# frozen_string_literal: true

require 'spec_helper'

describe MyBuilder do
  describe '#yard' do
    subject(:builder) do
      described_class.new(klass, rescue_error: true)
    end

    let(:klass)    { Class.new }
    let(:instance) { klass.new }

    describe '#build' do
      before do
        builder.add_methods
        builder.build
      end

      context 'when calling built method' do
        it 'returns default value' do
          expect(instance.symbolize).to eq(:default)
        end
      end
    end
  end
end
