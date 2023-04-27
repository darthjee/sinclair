# frozen_string_literal: true

require 'spec_helper'

describe MyBuilder do
  describe '#yard' do
    let(:klass) { Class.new }

    describe 'Passing building options (Used on subclasses)' do
      it 'builds the methods' do
        MyBuilder.build(klass, rescue_error: true) do
          add_methods
        end

        instance = klass.new

        expect(instance.symbolize).to eq(:default)
      end
    end
  end
end
