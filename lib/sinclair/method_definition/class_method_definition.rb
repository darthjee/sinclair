# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Builder capable of adding methods to instances
    class ClassMethodDefinition < MethodDefinition
      include Sinclair::OptionsParser

      # Default options of initialization
      DEFAULT_OPTIONS = {
        cached: false
      }.freeze

      # Creates a new instance based on arguments
      #
      # @return [ClassMethodDefinition] When block is given, a
      #   new instance of {ClassBlockDefinition} is returned,
      #   otherwise {ClassStringDefinition} is returned
      def self.from(name, code = nil, **options, &block)
        if block
          ClassBlockDefinition.new(name, **options, &block)
        else
          ClassStringDefinition.new(name, code, **options)
        end
      end

      # @param name    [String,Symbol] name of the method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      def initialize(name, **options)
        @name =    name
        @options = DEFAULT_OPTIONS.merge(options)
      end

      # Adds the class method to given klass
      #
      # This should be implemented on child classes
      #
      # @param _klass [Class] class which will receive the new method
      #
      # @return [Symbol] name of the created method
      def build(_klass)
        raise 'Build is implemented in subclasses. ' \
          "Use #{self.class}.from to initialize a proper object"
      end

      private

      # @private
      attr_reader :name, :code, :block
      delegate :cached, to: :options_object

      # @private
      #
      # Flag telling to use cached method
      #
      # @return [Boolean]
      alias cached? cached
    end
  end
end
