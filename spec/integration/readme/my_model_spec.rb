# frozen_string_literal: true

require 'spec_helper'

describe MyModel do
  subject(:model) { klass.new }

  let(:klass)   { Class.new(described_class) }
  let(:builder) { Sinclair.new(klass) }
  
  before do
    klass.send(:attr_accessor, :base, :expoent)

    builder.add_method(:cached_power, cached: true) do
      base ** expoent
    end

    builder.build

    model.base    = 3
    model.expoent = 2
  end

  it "caches the result of the method" do
    expect { model.expoent = 3 }
      .not_to change(model, :cached_power)
    expect(model.cached_power).to eq(9)
  end
end
