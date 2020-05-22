# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::OptionsParser do
  describe 'yard' do
    subject(:model) { described_class::Dummy.new(options) }

    let(:options) { { switch: false, option_1: 10, option_2: 20 } }

    describe '#the_method' do
      it 'returns the value for option given' do
        expect(model.the_method).to eq('The value is not 10 but 20')
      end
    end

    describe '.skip_validation' do
      it 'accepts options' do
        options = BuilderOptions.new(name: 'Joe', age: 10)

        expect(options.name).to eq('Joe')
        expect(options.try(:age)).to be_nil
      end
    end
  end
end
