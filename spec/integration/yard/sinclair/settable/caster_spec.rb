# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable::Caster do
  describe '#yard' do
    describe 'altering base caster' do
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

    describe 'creating a new caster' do
      subject(:settable) { JsonEnvSettings }

      let(:hash) { { key: 'value' } }

      before do
        ENV['JSON_CONFIG'] = hash.to_json
      end

      after do
        ENV.delete('JSON_CONFIG')
      end

      it 'retrieves data from env' do
        expect(settable.config).to eq(hash.stringify_keys)
      end
    end
  end
end
