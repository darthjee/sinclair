# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair#eval_and_add_method' do
  describe 'Building a initial value class method' do
    let(:klass) do
      Class.new do
        include InitialValuer
        attr_writer :age

        initial_value_for :age, 20
      end
    end

    context 'when it has not been initialized' do
      it do
        object = klass.new

        expect(object.age).to eq(20)
        object.age = 30
        expect(object.age).to eq(30)
      end
    end
  end
end
