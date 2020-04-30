# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  #
  # Class responsible to convert inputs into
  # hash of default values
  class InputHash
    # @api public
    #
    # Converts args into Hash
    #
    # @overload input_hash(*args)
    #   @param args [Array] Names attributes
    # @overload input_hash(*args, **hash))
    #   @param args [Array] Names attributes
    #   @param hash [Hash] already converted
    #     hahs
    #
    # @return [Hash]
    #
    # @example
    #   Sinclair::InputHash.input_hash(
    #     :key1, 'key2',
    #     key3: 10,
    #     'key4' => 20
    #   )
    #
    #   # returns
    #   # {
    #   #   key1: nil,
    #   #   'key2' => nil,
    #   #   key3: 10,
    #   #   'key4' => 20
    #   # }
    def self.input_hash(*args)
      new(*args).to_h
    end

    # @api private
    # @private
    #
    # Returns hash from initialization arguments
    #
    # @return [Hahs]
    def to_h
      hash_from_attributes.merge!(hash)
    end

    private

    attr_reader :attributes, :hash
    # @method attributes
    # @api private
    # @private
    #
    # Attribute list for creation of hash
    #
    # @return [Array<String,Symbol>]

    # @method hash
    # @api private
    # @private
    #
    # Hash already in hash format
    #
    # @return [Hash]

    # @api private
    # @rivate
    #
    # @overload initialize(*arguments)
    #   @param arguments [String,Symbol] attributes to generate
    #     hash keys
    # @overload initialize(*arguments, **hash)
    #   @param arguments [String,Symbol] attributes to generate
    #     hash keys
    #   @param hash [Hash] hash to be merged with final hash
    #     from attributes
    def initialize(*arguments)
      block = proc { |value| value.is_a?(Hash) }

      @attributes = arguments.reject(&block)
      @hash = arguments.find(&block) || {}
    end

    # @api private
    # @private
    #
    # Creates a hash of nil values using attributes as keys
    #
    # @return [Hash]
    def hash_from_attributes
      Hash[attributes.map { |*attribute| attribute }]
    end
  end
end
