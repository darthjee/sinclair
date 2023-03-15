# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  describe 'readme' do
    it 'initializes model' do
      human = Human.new(name: 'John Doe', age: 22)

      expect(human.name).to eq('John Doe')
      expect(human.age).to eq(22)
      expect(human.gender).to eq(:undefined)
    end
  end
end
