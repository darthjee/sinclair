# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Base class responsible for building methods
    class Base
      # Instantiate the class and build the method
      #
      # @param klass [Class] class to receive the method
      # @param definition [MethodDefinition] method defined
      # @param type [Symbol] type of method to be build
      #   - +:instance+ instance methods
      #   - +:class+ class methods
      #
      # @see #build
      #
      # @return (see #build)
      def self.build(klass, definition, type:)
        new(klass, definition, type: type).build
      end

      # @param klass [Class] class to receive the method
      # @param definition [MethodDefinition] method defined
      # @param type [Symbol] type of method to be build
      #   - +:instance+ instance methods
      #   - +:class+ class methods
      def initialize(klass, definition, type:)
        @klass = klass
        @definition = definition
        @type = type
      end

      # Build method (should be implemented in subclass)
      #
      # @return [Symbol] name of the method built
      #
      # @raise NotImplementedError
      def build
        raise NotImplementedError, 'Not implemented yet. this should be imlemented in subclasses'
      end

      private

      attr_reader :klass, :definition, :type
      # @method klass
      # @private
      # @api private
      #
      # Class to receive the methods
      #
      # @return [Class]

      # @method definition
      # @private
      # @api private
      #
      # return a definition object
      #
      # @return [MethodDefinition]

      # @method type
      # @private
      # @api private
      #
      # Type of method, class or instance
      #
      # @return [Symbol]

      # @private
      #
      # Checks if builder will build an instance method
      #
      # @return [TrueClass,FalseClass]
      def instance?
        type == INSTANCE_METHOD
      end
    end
  end
end
