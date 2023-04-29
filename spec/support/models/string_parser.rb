# frozen_string_literal: false

class StringParser < Sinclair::Caster
  master_caster!

  cast_with(JSON) { |value| JSON.parse(value) }
  cast_with(Integer, :to_i)
  cast_with(Float, :to_f)
end
