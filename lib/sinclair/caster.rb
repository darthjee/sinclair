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
    autoload :ClassMethods, 'sinclair/caster/class_methods'
    extend Caster::ClassMethods
    master_caster!

    # @method self.master_caster!
    # @api public
    #
    # Changes the class to be the master caster
    #
    # The master caster never checks with its an
    #
    # @example
    #   class MyCaster < Sinclair::Caster
    #   end
    #
    #   MyCaster.cast(10, :string) # returns '10'
    #
    #   MyCaster.master_caster!
    #
    #   MyCaster.cast(10, :string) # returns 10
    #
    # @see Caster::ClassMethods#master_caster!
    #
    # @return [TrueClass]

    # @method self.cast_with
    # @api public
    #
    # Register a caster under a key
    #
    # @overload cast_with(key, method_name)
    #   @param key [Symbol] key where the caster will be store.
    #   @param method_name [Symbol] method to be called on the
    #     value that is being converted
    #
    #   @example
    #     class MyCaster < Sinclair::Caster
    #       cast_with(:json, :to_json)
    #     end
    #
    #     my_caster.cast({ key: :value }, :json) # returns '{"key":"value"}'
    #
    # @overload cast_with(key, &block)
    #   @param key [Symbol] key where the caster will be store.
    #   @param block [Proc] block to be used when casting the value.
    #
    #   @example Casting from pre registered block caster
    #     class MyCaster < Sinclair::Caster
    #       cast_with(Numeric, :to_i)
    #     end
    #
    #     MyCaster.cast_with(:complex) do |hash|
    #       real = hash[:real]
    #       imaginary = hash[:imaginary]
    #
    #       "#{real.to_f} + #{imaginary.to_f} i"
    #     end
    #
    #     value = { real: 10, imaginary: 5 }
    #
    #     MyCaster.cast(value, :complex) # returns '10.0 + 5.0 i'
    #
    # @overload cast_with(class_key, method_name)
    #   @param class_key [Class] class to be used as key.
    #     This will be used as parent class when the calling {Caster.cast}.
    #   @param method_name [Symbol] method to be called on the
    #     value that is being converted.
    #
    #   @example Casting from pre registered class
    #     class MyCaster < Sinclair::Caster
    #       cast_with(Numeric, :to_i)
    #     end
    #
    #     MyCaster.cast('10', Integer) # returns 10
    #
    # @overload cast_with(class_key, &block)
    #   @param class_key [Class] class to be used as key.
    #     This will be used as parent class when the calling {Caster.cast}.
    #   @param block [Proc] block to be used when casting the value.
    #
    # @see Caster::ClassMethods#cast_with
    # @see Caster.caster_for
    # @see Caster.cast
    #
    # @return [Caster] the registered caster

    # @method self.cast
    # @api public
    #
    # Cast a value using the registered caster
    #
    # @overload cast(value, key, **opts)
    #   @param value [Object] value to be cast
    #   @param key [Symbol] key where the caster is registered under
    #   @param opts [Hash] Options to be sent to the caster
    #
    # @overload cast(value, class_key, **opts)
    #   @param value [Object] value to be cast
    #   @param class_key [Class] Class to used as key in the casters storage
    #   @param opts [Hash] Options to be sent to the caster
    #
    #   When the +class_key+ does not match the stored key, but matches a superclass,
    #   the registerd caster is returned.
    #
    # @see Caster::ClassMethods#cast
    # @see Caster.cast_with
    # @see Caster.caster_for
    # @see Caster#cast
    #
    # @return [Object] the value cast

    # @method self.caster_for
    # @api public
    #
    # Returns an instance of caster for the provided key
    #
    # When no registered caster is found one is requested for the parent class.
    # If no caster is found, then a default caster is returned
    #
    # The default caster performs no casting returning the value itself
    #
    # @overload caster_for(key)
    #   @param key [Symbol] key where the caster is registered under
    #
    # @overload caster_for(class_key)
    #   @param class_key [Class] Class to used as key in the casters storage
    #
    #   When the +class_key+ does not match the stored key, but matches a superclass,
    #   the registerd caster is returned.
    #
    # @see Caster::ClassMethods#caster_for
    # @see Caster.cast_with
    # @see Caster.cast
    #
    # @return [Caster]

    # @param block [Proc] Proc to be used when converting the value object
    def initialize(&block)
      @block = block.to_proc
    end

    # Cast a value using the given the set +block+
    #
    # @param value [Object] value to be converted
    # @param opts [Hash] options to be sent to the block
    #
    # When the block does not accept options, those
    # are not passed
    #
    # @return [Object] the result of the converting block
    def cast(value, **opts)
      options = opts.select do |key, _|
        options_keys.include?(key)
      end

      block.call(value, **options)
    end

    private

    # @api private
    # @private
    #
    # Keys of options accepted by the block
    #
    # @return [Array<Symbol>]
    def options_keys
      @options_keys ||= block.parameters.select do |(type, _)|
        %i[key keyreq].include? type
      end.map(&:second)
    end

    # @method block
    # @api private
    # @private
    #
    # Proc to be used when converting the value object
    #
    # @return [Proc]
    attr_reader :block

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
