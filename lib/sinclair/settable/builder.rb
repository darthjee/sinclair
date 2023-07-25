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

      def initialize(klass, prefix, read_with, *settings_name, **defaults)
        super(klass, prefix: prefix)

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

      delegate :prefix, to: :options_object
      # @method prefix
      # @private
      # @api private
      #
      # Env keys prefix
      #
      # @return [String]

      # @private
      # @api private
      #
      # Process all settings adding the methods
      #
      # @return (see settings)
      def add_all_methods
        settings.each do |name, value|
          key = [prefix, name].compact.join('_').to_s.upcase

          add_class_method(name) do
            ENV[key] || value
          end
        end
      end
    end
  end
end
