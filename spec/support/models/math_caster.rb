# frozen_string_literal: false

class MathCaster < Sinclair::Caster
  cast_with(:float, :to_f)

  cast_with(:log) do |value, base: 10|
    value = MathCaster.cast(value, :float)

    Math.log(value, base)
  end

  cast_with(:exp) do |value, base: 10|
    value = MathCaster.cast(value, :float)

    base**value
  end
end
