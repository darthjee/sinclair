# frozen_string_literal: true

class Sinclair
  class Caster
    class << self
      def cast_with(key, method_name = nil, &block)
        casters[key] = instance_for(method_name, &block)
      end

      def cast(value, key, **opts)
        caster_for(key).cast(value, **opts)
      end

      def caster_for(key)
        casters[key] || caster_superclass&.caster_for(key) || new { |v| v }
      end

      protected

      def instance_for(method_name, &block)
        return new(&block) unless method_name
        return method_name if method_name.is_a?(Caster)

        new(&method_name)
      end

      private

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

    def cast(value, **opts)
      block.call(value, **opts)
    end

    private

    attr_reader :block

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
