# frozen_string_literal: true

class Sinclair
  module Settable
    # @api public
    #
    # Class responsible for casting the values
    #
    # New types can be added
    #
    # @example Adding a casting type to {Sinclair::Settable::Caster Sinclair::Settable::Caster}
    #   class Sinclair
    #     module Settable
    #       class Caster
    #         cast_with(:squared) { |value| value.to_f**2 }
    #       end
    #     end
    #   end
    #
    #   class MathEnvSettings
    #     extend Sinclair::EnvSettable
    #
    #     settings_prefix 'MATH'
    #
    #     setting_with_options :value, type: :squared
    #   end
    #
    #   ENV['MATH_VALUE'] = '80'
    #
    #   settable.value # returns 6400.0
    class Caster < Sinclair::Caster
      cast_with(:integer, &:to_i)
      cast_with(:string, &:to_s)
      cast_with(:float, &:to_f)
    end
  end
end
