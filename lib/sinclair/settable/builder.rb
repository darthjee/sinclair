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

      delegate :type, to: :options_object
      attr_reader :settings, :settable_module

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
        options   = call_options
        block     = read_block
        caster    = caster_class
        cast_type = type

        add_class_method(name, cached: :full) do
          value = instance_exec(name, **options, &block)

          value ? caster.cast(value, cast_type) : nil
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

      def read_block
        @read_block ||= klass.read_with
      end

      def caster_class
        settable_module::Caster
      end
    end
  end
end
