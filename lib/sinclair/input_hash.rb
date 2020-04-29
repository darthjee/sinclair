# frozen_string_literal: true

class Sinclair
  # @api privat
  # @author Darthjee
  #
  # Class responsible to convert inputs into
  # hash of default values
  class InputHash
    # @api private
    # @private
    #
    # Converts args into Hash
    #
    # @overload input_hash(*args)
    #   @param args [Array] Names attributes
    # @overload input_hash(*args, **hash))
    #   @param args [Array] Names attributes
    #   @param defaults [Hash] already converted
    #     hahs
    #
    # @return Hash
    def self.input_hash(*args)
      new(*args).to_h
    end

    def to_h
      hash_from_names.merge!(defaults)
    end

    private

    attr_reader :names, :defaults

    def initialize(*arguments)
      block = proc { |value| value.is_a?(Hash) }

      @names = arguments.reject(&block)
      @defaults = arguments.find(&block) || {}
    end

    def hash_from_names
      Hash[names.map { |*name| name }]
    end
  end
end
