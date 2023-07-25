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
      def initialize(klass, settable_module, *settings_name, **options)
        super(klass, **options)

        @settings = settings_name
        @settable_module = settable_module

        add_all_methods
      end

      private

      attr_reader :settings, :settable_module
      delegate :read_with, to: :klass

      alias read_block read_with

      # @private
      # @api private
      #
      # Process all settings adding the methods
      #
      # @return (see settings)
      def add_all_methods
        settings.each do |name|
          add_setting_method(name)
        end
      end

      def add_setting_method(name)
        options = call_options
        block = read_block

        add_class_method(name, cached: :full) do
          block.call(name, **options)
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
