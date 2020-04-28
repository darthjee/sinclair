# frozen_string_literal: true

class Sinclair
  # @api privat
  # @author Darthjee
  #
  # Module responsible to convert inputs into
  # hash of default values
  module InputHashable
    private

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
    def input_hash(*args)
      defaults = args.find { |arg| arg.is_a?(Hash) } || {}
      args.delete(defaults)

      hash = Hash[args.map { |*name| name }]
      hash.merge!(defaults)
    end
  end
end
