# frozen_string_literal: true

class Sinclair
  module Settable
    # @api private
    # @author darthjee
    #
    # Env setting methods builder
    #
    # This builder does the magic of adding methods
    # that will fetch variables from env or a default value
    class Builder < Sinclair
      attr_reader :read_block

      def initialize(klass, read_block, *settings_name, **defaults)
        super(klass)

        @settings = Sinclair::InputHash.input_hash(*settings_name, **defaults)
        @read_block = read_block

        add_all_methods
      end

      private

      attr_reader :settings
      # @method settings
      # @private
      # @api private
      #
      # Settings map with default values
      #
      # @return [Hash<Symbol,Object>]

      # @private
      # @api private
      #
      # Process all settings adding the methods
      #
      # @return (see settings)
      def add_all_methods
        settings.each do |name, value|
          key   = name
          block = read_block

          add_class_method(name) do
            block.call(key, self, value)
          end
        end
      end
    end
  end
end
