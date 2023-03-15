# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Model#for' do
  it 'Creating a Simple model' do
    car = Car.new(brand: :ford, model: :T)

    expect(car.brand).to eq(:ford)
    expect(car.model).to eq(:T)
  end

  it 'Creating a model with default values and writter' do
    job = Job.new

    expect(job.state).to eq(:starting)
    job.state = :done
    expect(job.state).to eq(:done)
  end
end
