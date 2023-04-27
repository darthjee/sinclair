# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yard for .build' do
    before { allow(Random).to receive(:rand).and_return(803) }

    it 'Simple usage' do
      model_class = Class.new

      Sinclair.build(model_class) do
        add_method(:random_name, cached: true) do
          "John #{Random.rand(1000)} Doe"
        end
      end

      model = model_class.new

      expect(model.random_name).to eq('John 803 Doe')
    end
  end
end
