# frozen_string_literal: true

class Sinclair
  class Caster
    class << self
      def cast_with(key, method_name = nil, &block)
        block = method_name ? method_name.to_proc : block

        casters[key] = new(&block)
      end

      def cast(value, klass)
        return value unless caster_defined?(klass)

        cast_value(klass, value)
      end

      protected

      def caster_for(key)
        casters[key] || caster_superclass&.caster_for(key)
      end

      def caster_defined?(key)
        casters.key?(key) || caster_superclass&.caster_defined?(key)
      end

      private

      def cast_value(key, value)
        caster_for(key).cast(value)
      end

      def casters
        @casters ||= {}
      end

      def caster_superclass
        return if self == Sinclair::Caster

        superclass
      end
    end

    def initialize(&block)
      @block = block.to_proc
    end

    def cast(value)
      block.call(value)
    end

    private

    attr_reader :block

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
