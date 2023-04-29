# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Caster.cast' do
  it 'Getting the caster with symbol key' do
    expect(EnumConverter.to_array({ key: :value })).to eq([%i[key value]])
    expect(EnumConverter.to_hash([%i[key value]])).to eq({ key: :value })
  end

  it 'Getting the caster with class key' do
    expect(StringParser.cast('{"key":"value"}', JSON)).to eq({ "key" => "value" })
    expect(StringParser.cast('10.2', Integer)).to eq(10)
    expect(StringParser.cast('10.2', Float)).to eq(10.2)
  end
end
