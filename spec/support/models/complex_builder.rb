# frozen_string_literal: true

class ComplexBuilder < Sinclair
  def initialize(klass, value, power)
    @value = value
    @power = power

    super(klass)
  end

  def add_default
    val = @value
    pow = @power

    add_method(:result) { val**pow }
  end
end
