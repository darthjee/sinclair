# frozen_string_literal: true

class Sinclair
  class Caster
    # @api public
    # @author darhtjee
    #
    # Class methods for {Caster}
    module ClassMethods
      # (see Caster.master_caster!)
      def master_caster!
        @master_caster = true
      end

      # (see Caster.cast_with)
      def cast_with(key, method_name = nil, &block)
        caster = instance_for(method_name, &block)

        return class_casters[key] = caster if key.is_a?(Class)

        casters[key] = caster
      end

      # (see Caster.cast)
      def cast(value, key, **opts)
        caster_for(key).cast(value, **opts)
      end

      # (see Caster.caster_for)
      def caster_for(key)
        return new { |value| value } if key.nil?
        return casters[key] if casters.key?(key)

        caster_for_class(key) || superclas_caster_for(key) || new { |value| value }
      end

      protected

      # @api private
      #
      # Returns a caster from the superclass
      #
      # @param key [Symbol,Class] key to be checked
      #
      # @see caster_for
      # @return [Caster]
      def superclas_caster_for(key)
        return if master_caster?

        superclass.caster_for(key)
      end

      # @api private
      #
      # Returns a caster searching for using class as key
      #
      # This is called by {#caster_for} any time key is a class
      #
      # @param klass [Class] class to be used in the search
      #
      # When the given class is not registered, a caster for a parent
      # class is returned
      #
      # @return [Caster]
      def caster_for_class(klass)
        class_casters.find do |klazz, _|
          klass <= klazz
        end&.second
      end

      # @api private
      #
      # Returns a new instance {Caster}
      #
      # @overload instance_for(method_name, &block)
      #   @param method_name [Symbol] method to be called in the model
      #   @param block [Proc] block to perform the casting
      #
      #   When +method_name+ is not given, the block is used
      #
      # @overload instance_for(caster)
      #   @param caster [Caster] instance of caster to be returned
      #
      # @return [Caster]
      def instance_for(method_name, &block)
        return new(&block) unless method_name
        return method_name if method_name.is_a?(Caster)

        new(&method_name)
      end

      private

      # @api private
      # @private
      #
      # Caster map stored by +Symbols+
      #
      # @return [Hash<Symbol,Caster>]
      def casters
        @casters ||= {}
      end

      # @api private
      # @private
      #
      # Caster map stored by +Classs+
      #
      # @return [Hash<Class,Caster>]
      def class_casters
        @class_casters ||= {}
      end

      # @api private
      # @private
      #
      # Chack if the caster class is a master
      #
      # A master caster never checks if a superclass has a caster
      #
      # @see master_caster!
      # @return [TrueClass,FalseClass]
      def master_caster?
        @master_caster
      end
    end
  end
end
