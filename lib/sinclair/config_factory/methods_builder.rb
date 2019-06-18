# frozen_string_literal: true

class Sinclair
  class ConfigFactory
    # @api private
    #
    # Class responsible for adding method to configuration
    # classes
    class MethodsBuilder < Sinclair
      # @param klass [Class] class inheriting from {Sinclair::Config}
      #  that will receive the methods
      # @overload initialize(klass, *names, default)
      #   @param names [Array<Symbol,String>] List of configuration names
      #   to be added
      #   @param default [Hash] Configurations that will receive a default
      #   value when not configured
      def initialize(klass, *names)
        super(klass)

        @names = names
        @defaults = names.find { |arg| arg.is_a?(Hash) } || {}
        names.delete(defaults)
      end

      # Build the methods in config class
      #
      # Methods will be attribute readers that, when an attribute
      # (instance variable) has never been defined, a default value
      # is returned
      #
      # Setting an instance variable to nil will not return default
      # value.
      #
      # If default value is required, {Sinclair::Configurable#reset_config}
      # should be called
      #
      # @return (see Sinclair#build)
      #
      # @see Sinclair#build
      def build
        config_hash.each do |method, value|
          add_method(method, cached: :full) { value }
        end

        super
      end

      # Returns the name of all configs defined by {MethodsBuilder}
      #
      # @return [Array<String,Symbol>]
      def config_names
        config_hash.keys
      end

      private

      attr_reader :names, :defaults

      # @private
      #
      # Builds the final config hash
      #
      # Config hash merges defauls config hashs
      # with {#name_as_hash}
      #
      # @return [Hash]
      def config_hash
        @config_hash ||= names_as_hash.merge!(defaults)
      end

      # @private
      #
      # Builds a hash with nil values from config names
      #
      # @return [Hash]
      def names_as_hash
        Hash[names.map { |*name| name }]
      end
    end
  end
end
