# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  describe 'readme' do
    it 'Simple usage' do
      human1 = Human.new(name: 'John Doe', age: 22)
      human2 = Human.new(name: 'John Doe', age: 22)

      expect(human1.name).to eq('John Doe')
      expect(human1.age).to eq(22)
      expect(human1.gender).to eq(:undefined)
      expect(human1 == human2).to eq(true)
    end

    it 'Without comparable' do
      tv1 = Tv.new(model: 'Sans Sunga Xt')
      tv2 = Tv.new(model: 'Sans Sunga Xt')

      expect(tv1 == tv2).to eq(false)
    end
  end
end
