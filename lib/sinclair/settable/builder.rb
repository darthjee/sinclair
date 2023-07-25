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
      def initialize(klass, read_block, *settings_name, **options)
        super(klass, **options)

        @settings = settings_name
        @read_block = read_block

        add_all_methods
      end

      private

      delegate :default, to: :options_object

      attr_reader :settings, :read_block

      # @private
      # @api private
      #
      # Process all settings adding the methods
      #
      # @return (see settings)
      def add_all_methods
        settings.each do |name|
          key   = name
          opts  = options
          block = read_block

          add_class_method(name) do
            block.call(key, self, **opts)
          end
        end
      end
    end
  end
end
