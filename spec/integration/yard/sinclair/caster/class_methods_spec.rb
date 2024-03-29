# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Caster::ClassMethods' do
  let(:my_caster) { Class.new(superclass) }

  let(:superclass) do
    Class.new(Sinclair::Caster) do
      cast_with(:string, :to_s)
    end
  end

  describe '.master_caster!' do
    it 'Making a class to be a master caster' do
      expect(my_caster.cast(10, :string)).to eq('10')

      my_caster.master_caster!

      expect(my_caster.cast(10, :string)).to eq(10)
    end
  end
end
