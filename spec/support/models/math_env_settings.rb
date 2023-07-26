# frozen_string_literal: true

class Sinclair
  module Settable
    class Caster
      cast_with(:squared) { |value| value.to_f**2 }
    end
  end
end

class MathEnvSettings
  extend Sinclair::EnvSettable

  settings_prefix 'MATH'

  setting_with_options :value, type: :squared
end
