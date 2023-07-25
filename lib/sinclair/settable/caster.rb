# frozen_string_literal: true

class Sinclair
  module Settable
    class Caster < Sinclair::Caster
      cast_with(:integer, &:to_i)
      cast_with(:string, &:to_s)
      cast_with(:float, &:to_f)
    end
  end
end
