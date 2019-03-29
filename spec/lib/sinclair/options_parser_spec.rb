# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::OptionsParser do
  subject(:model) { klass.new(options) }

  let(:klass)    { described_class::Dummy }
  let(:switched) { true }
  let(:value_1)  { 'value1' }
  let(:options)  { { switch: switched, option_1: value_1, option_2: 2 } }

  it 'enables the given options to be acced' do
    expect(model.the_method).to eq('The value is value1')
  end

  context 'when changing the options' do
    let(:switched) { false }

    it 'enables the given options to be acced' do
      expect(model.the_method).to eq('The value is not value1 but 2')
    end
  end

  context 'when there is an option missing' do
    let(:options) { { option_1: 'value1', option_2: 2 } }

    it do
      expect { model.the_method }.not_to raise_error
    end

    it 'considers is to be nil' do
      expect(model.the_method).to eq('missing option')
    end
  end

  context 'when changing the options before the option call' do
    before do
      model
      options[:switch] = false
    end

    it 'does not reevaluate the options' do
      expect(model.the_method).to eq('The value is value1')
    end

    context 'when the option value is another object on its own' do
      let(:value_1) { { key: 'value' } }

      before do
        model
        options[:option_1][:key] = 100
      end

      it 'does not reevaluate the options' do
        expect(model.the_method).to eq('The value is {:key=>"value"}')
      end
    end
  end
end
