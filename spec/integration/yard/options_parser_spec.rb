# frozen_string_literal: true

require 'spec_helper'

describe 'yard' do
  describe Sinclair::OptionsParser do
    let(:options) { { switch: false, option_1: 10, option_2: 20 } }
    subject { described_class::Dummy.new(options) }

    describe '#the_method' do
      it 'returns the value for option given' do
        expect(subject.the_method).to eq('The value is not 10 but 20')
      end
    end
  end
end
