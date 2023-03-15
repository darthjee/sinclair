# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Model#for' do
  it 'Creating a Simple model' do
    car = Car.new(brand: :ford, model: :T)

    expect(car.brand).to eq(:ford)
    expect(car.model).to eq(:T)
  end
end
