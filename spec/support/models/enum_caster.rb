# frozen_string_literal: false

class EnumCaster < Sinclair::Caster
  cast_with(:hash, :to_h)
  cast_with(:array, :to_a)
end
