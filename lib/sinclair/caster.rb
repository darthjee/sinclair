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
    master_caster

    # @method self.master_caster
    # @api public
    #
    # The master caster never checks with its an
    #
    # @see Caster::ClassMethods#master_caster

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
    # @overload cast_with(key, &block)
    #   @param key [Symbol] key where the caster will be store.
    #   @param block [Proc] block to be used when casting the value.
    #
    # @overload cast_with(class_key, method_name)
    #   @param class_key [Class] class to be used as key.
    #     This will be used as parent class when the calling {Caster.cast}.
    #   @param method_name [Symbol] method to be called on the
    #     value that is being converted.
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

    # @method self.caster_for

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

    # @private
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
