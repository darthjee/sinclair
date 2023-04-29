# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair::Caster' do
  describe '.cast' do
    it 'Casts with a symbol key' do
      initial = Random.rand(10..20)
      log = MathCaster.cast(initial, :log)
      exp = MathCaster.cast(log, :exp)

      expect(exp).to be_between(initial - 0.0001, initial + 0.0001)
    end

    it 'Casts passing parameter' do
      base = Random.rand(3..6)
      initial = Random.rand(10..20)
      log = MathCaster.cast(initial, :log, base: base)
      exp = MathCaster.cast(log, :exp, base: base)

      expect(exp).to be_between(initial - 0.0001, initial + 0.0001)
    end

    it 'Casts with class key' do
      hash = { a: 1, b: 2, 'c' => nil }
      string = 'my string'
      symbol = :the_symbol
      number = 10
      null = nil

      code = <<-RUBY
        hash_value = #{RubyStringCaster.to_ruby_string(hash)}
        string_value = #{RubyStringCaster.to_ruby_string(string)}
        symbol_value = #{RubyStringCaster.to_ruby_string(symbol)}
        number = #{RubyStringCaster.to_ruby_string(number)}
        null_value = #{RubyStringCaster.to_ruby_string(null)}
      RUBY

      expect(code).to eq(<<-RUBY)
        hash_value = {:a=>1, :b=>2, "c"=>nil}
        string_value = "my string"
        symbol_value = :the_symbol
        number = 10
        null_value = nil
      RUBY
    end
  end

  describe '#cast' do
    it 'Casts from a selected caster' do
      caster = MathCaster.caster_for(:log)

      expect(caster.cast(100)).to eq(2)
      expect(caster.cast(8, base: 2)).to eq(3)
    end
  end
end
