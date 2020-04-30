# frozen_string_literal: true

class Sinclair
  class Options
    # @api private
    # @author Darthjee
    #
    # Option Class Builder
    #
    # This class builds methods for options objects
    class Builder < Sinclair
      # @param klass [Class] options class to receive
      #   methods
      # @param options [Array<Symbol>] list of accepted
      #   options
      # @param defaults [Hash<Symbol,Object>] default options
      #   hash
      def initialize(klass, *options, **defaults)
        super(klass)

        @attributes = Sinclair::InputHash.input_hash(*options, **defaults)

        add_all_methods
      end

      private

      attr_reader :attributes
      # @method attributes
      # @api private
      # @private
      #
      # Options attributes
      #
      # @return [Hash<Symbol.Object>]

      # Add all methods for options
      #
      # @return [Array<MethodDefinition>]
      def add_all_methods
        attributes.each do |option, value|
          add_method(option, cached: true) { value }
          klass.allowed_options.push(option)
        end
      end
    end
  end
end
