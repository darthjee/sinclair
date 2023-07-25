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
          add_setting_method(name, **call_options, &read_block)
        end
      end

      def add_setting_method(name, **opts, &block)
        add_class_method(name, cached: :full) do
          block.call(name, **opts)
        end
      end

      def call_options
        @call_options ||= options.slice(*read_block_options)
      end

      def read_block_options
        @read_block_options ||= read_block.parameters.select do |(type, _name)|
          type == :key
        end.map(&:second)
      end
    end
  end
end
