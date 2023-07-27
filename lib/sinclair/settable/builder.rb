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
      # @param klass [Class] Setting class where the methods will be added to
      # @param settable_module [Module] Module of settable that the class extends
      # @param settings_name [Array<Symbol>] list of all settings to be added
      # @param options [Hash] Options of setting.
      #
      #   Each settable might have their own set options defined in
      #   {Sinclair::Settable::ClassMethods#read_with Settable.read_with},
      #   and then passed to the buildr on
      #   {Sinclair::Settable#setting_with_options Settable#setting_with_options}
      #
      # @option options type [Symbol] type to cast the value fetched
      def initialize(klass, settable_module, *settings_name, **options)
        super(klass, **options)

        @settings = settings_name
        @settable_module = settable_module

        add_all_methods
      end

      private

      delegate :type, to: :options_object
      # @method type
      # @private
      # @api private
      #
      # Returns the type to cast the retrieved value
      #
      # @return [Symbol]

      attr_reader :settings, :settable_module
      # @method settings
      # @private
      # @api private
      #
      # Name of all settings to be added
      #
      # @return [Array<Symbol>]

      # @method settable_module
      # @private
      # @api private
      #
      # Module of settable that the class extends
      #
      # @return [Module]

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

      # @private
      #
      # Add one setting class method to settings class
      #
      # @return (see Sinclair#add_class_method)
      def add_setting_method(name)
        options   = call_options
        block     = read_block
        caster    = caster_class.caster_for(type)

        add_class_method(name, cached: :full) do
          value = instance_exec(name, **options, &block)

          value ? caster.cast(value) : nil
        end
      end


      # @private
      #
      # Options that will be accepted by {read_block}
      #
      # The given options are sliced based on the accepted parameters
      # from read_blocks
      #
      # @see read_block_options
      # @see Settable::ClassMethods#read_with
      # @return [Hash<Symbol, Object>]
      def call_options
        @call_options ||= options.slice(*read_block_options)
      end

      # @private
      #
      # List all keys accepted by {read_block}
      #
      # @see call_options
      # @see Settable::ClassMethods#read_with
      # @return [Array<Symbol>]
      def read_block_options
        read_block.parameters.select do |(type, _name)|
          type == :key
        end.map(&:second)
      end

      # @private
      #
      # Returns proc for extracting values when reading a setting
      #
      # @see add_setting_method
      # @see Settable::ClassMethods#read_with
      # @return [Proc]
      def read_block
        @read_block ||= klass.settable_module.read_with
      end

      # @private
      #
      # Returns caster configured for casting the returning values
      #
      # @return [Class<Settable::Caster>]
      def caster_class
        settable_module::Caster
      end
    end
  end
end
