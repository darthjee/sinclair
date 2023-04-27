# frozen_string_literal: true

class Sinclair
  module Caster
    class << self
      def cast_with(key, &block)
        casters[key] = block
      end

      def cast(value, klass)
        return value unless caster_defined?(klass)

        cast_value(klass, value)
      end

      private

      def cast_value(key, value)
        casters[key].to_proc.call(value)
      end

      def casters
        @casters ||= {}
      end

      def caster_defined?(key)
        casters.key?(key)
      end
    end

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
