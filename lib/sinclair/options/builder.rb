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
      # @overload initialize(klass, *options)
      #   @param klass [Class] options class to receive
      #     methods
      #   @param options [Array<Symbol>] list of accepted
      #     options
      # @overload initialize(klass, *options, **defaults)
      #   @param klass [Class] options class to receive
      #     methods
      #   @param options [Array<Symbol>] list of accepted
      #     options
      #   @param defaults [Hash<Symbol,Object>] default options
      #     hash
      def initialize(klass, *options)
        super(klass)

        @attributes = Sinclair::InputHash.input_hash(*options)
      end

      # Finish building options
      #
      # Add options to allowed options
      # and adds all methods
      #
      # @see Sinclair#build
      # @return (see Sinclair#build)
      def build
        add_all_methods
        add_filds_to_equals

        super
      end

      private

      # @api private
      # @private
      #
      # Options attributes
      #
      # @return [Hash<Symbol.Object>]
      attr_reader :attributes

      # Add all methods for options
      #
      # @return [Array<MethodDefinition>]
      def add_all_methods
        attributes.each do |option, value|
          add_method(option, cached: :full) { value }
          klass.allow(option)
        end
      end

      # Add the fields to equals comparation
      #
      # @return (see Sinclair::EqualsChecker#add)
      def add_filds_to_equals
        klass.comparable_by(*attributes.keys)
      end
    end
  end
end
