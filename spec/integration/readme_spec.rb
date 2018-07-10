# frozen_string_literal: true

require 'spec_helper'

describe 'Stand Alone' do
  let(:instance) { klass.new }
  let(:klass) { Class.new }
  let(:builder) { Sinclair.new(klass) }

  before do
    builder.add_method(:twenty, '10 + 10')
    builder.add_method(:eighty) { 4 * twenty }
    builder.build
  end

  it 'knows how to add string defined methods' do
    expect("Twenty => #{instance.twenty}").to eq('Twenty => 20')
  end

  it 'knows how to add block defined methods' do
    expect("Eighty => #{instance.eighty}").to eq('Eighty => 80')
  end
end
