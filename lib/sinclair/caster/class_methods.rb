# frozen_string_literal: true

class Sinclair
  class Caster
    # @api public
    # @author darhtjee
    #
    # Class methods for {Caster}
    module ClassMethods
      def master_caster
        @master_caster = true
      end

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
        return if master_caster?

        superclass.caster_for(key)
      end

      def caster_for_class(klass)
        class_casters.find do |klazz, _|
          klass <= klazz
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

      def master_caster?
        @master_caster
      end
    end
  end
end
