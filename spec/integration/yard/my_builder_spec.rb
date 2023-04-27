# frozen_string_literal: true

require 'spec_helper'

describe MyBuilder do
  describe '#yard' do
    subject(:builder) do
    end

    let(:klass)    { Class.new }

    describe 'Passing building options (Used on subclasses)' do
      it 'builds the methods' do
        builder = MyBuilder.new(klass, rescue_error: true)

        builder.add_methods
        builder.build

        instance klass.new 

        expect(instance.symbolize).to eq(:default)
      end
    end
  end
end
