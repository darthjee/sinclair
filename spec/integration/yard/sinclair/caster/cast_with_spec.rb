# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Caster.cast_with' do
  let(:my_caster) { Class.new(Sinclair::Caster) }

  it 'Casting from pre registered symbol caster' do
    my_caster.cast_with(:json, :to_json)

    expect(my_caster.cast({ key: :value }, :json)).to eq('{"key":"value"}')
  end

  it 'Casting from pre registered block caster' do
    my_caster.cast_with(:complex) do |hash|
      real = hash[:real]
      imaginary = hash[:imaginary]

      "#{real.to_f} + #{imaginary.to_f} i"
    end

    value = { real: 10, imaginary: 5 }

    expect(my_caster.cast(value, :complex)).to eq('10.0 + 5.0 i')
  end

  it 'Casting from pre registered class' do
    my_caster.cast_with(Numeric, :to_i)

    expect(my_caster.cast('10', Integer)).to eq(10)
  end

  it 'Casting from pre registered block caster from a class' do
    my_caster.cast_with(HashModel) do |value, klass:|
      klass.new(value)
    end

    my_caster.cast_with(String, &:to_json)

    values = [
      { klass: String, value: { name: 'john', age: 20, country: 'BR' } },
      { klass: HashPerson, value: { name: 'Mary', age: 22, country: 'IT' } }
    ]

    values.map! do |config|
      value = config[:value]
      klass = config[:klass]
      my_caster.cast(value, klass, klass:)
    end

    expect(values[0]).to eq('{"name":"john","age":20,"country":"BR"}')
    expect(values[1]).to eq(HashPerson.new(name: 'Mary', age: 22))
  end
end
