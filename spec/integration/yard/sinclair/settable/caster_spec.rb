# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable::Caster do
  describe '#yard' do
    subject(:settable) { MathEnvSettings }

    before do
      ENV['MATH_VALUE'] = '80'
    end

    after do
      ENV.delete('MATH_VALUE')
    end

    it 'retrieves data from env' do
      expect(settable.value).to eq(6400.0)
    end
  end
end
