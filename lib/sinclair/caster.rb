# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darhtjee
  #
  # Class responsible for defining how to and casting values
  #
  # First the class needs to be configured using {.cast_with} and later
  # a value can be cast by using {.cast} or {.caster_for}
  #
  # Inheritance grants the hability to have different casting for different
  # purposes / applications / gems
  class Caster
    class << self
      def cast_with(key, method_name = nil, &block)
        caster = instance_for(method_name, &block)

        return class_casters[key] = caster if key.is_a?(Class)

        casters[key] = caster
      end

      def cast(value, key, **opts)
        caster_for(key).cast(value, **opts)
      end

      def caster_for(key)
        return casters[key] if casters.key?(key)

        caster_for_class(key) || superclas_caster_for(key) || new { |value| value }
      end

      protected

      def superclas_caster_for(key)
        return if master_class?

        superclass.caster_for(key)
      end

      def caster_for_class(klass)
        class_casters.find do |klazz, _|
          klass == klazz || klass < klazz
        end&.second
      end

      def instance_for(method_name, &block)
        return new(&block) unless method_name
        return method_name if method_name.is_a?(Caster)

        new(&method_name)
      end

      private

      def casters
        @casters ||= {}
      end

      def class_casters
        @class_casters ||= {}
      end

      def master_class?
        @master_class ||= self == Sinclair::Caster
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
