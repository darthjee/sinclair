# frozen_string_literal: true

class Sinclair
  class Model
    # @api private
    # @author Darthjee
    #
    # Builder responsible for building methods to a new {Sinclair::Model} class
    #
    # The building adds readers/setters and an initializer with named parameters
    class Builder < Sinclair
      # @overload initialize(klass, *attributes, writter: true, comparable: true)
      #   @param klass [Class<Sinclair::Model>] the new class to receive the methods
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      # @overload initialize(klass, *attributes, defaults, writter: true, comparable: true)
      #   @param klass [Class<Sinclair::Model>] the new class to receive the methods
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param defaults [Hash] attributes to be added with a default value in the initializer
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      def initialize(klass, *attributes, writter: true, comparable: true)
        super(klass)
        @attributes = attributes.flatten
        @writter    = writter
        @comparable = comparable

        add_methods
        change_equals
        change_initializer
      end

      private

      attr_reader :attributes, :writter, :comparable
      alias writter? writter
      alias comparable? comparable

      # @!method attributes
      # @api private
      # @private
      #
      # Attributes to be added in the class
      #
      # Attributes without default values are symbols
      # while attributes with defaults values are defined in a Hash
      #
      # @return [Array<Symbol,Hash>]

      # @!method writter
      # @api private
      # @private
      #
      # Flag if writter methods (setter) should be added or not
      #
      # @return [TrueClass,FalseClass]

      # @!method comparable
      # @api private
      # @private
      #
      # flag to make the class {Comparable} by the fields
      #
      # @return [TrueClass,FalseClass]

      # @!method writter?
      # @api private
      # @private
      #
      # Flag if writter methods (setter) should be added or not
      #
      # @return [TrueClass,FalseClass]

      # @!method comparable?
      # @api private
      # @private
      #
      # flag to make the class {Comparable} by the fields
      #
      # @return [TrueClass,FalseClass]

      # @private
      # Adds readers and setters
      #
      # Readers are always added, while setters depends on the flag {#writter?}
      #
      # @return [Array<MethodDefinition>]
      def add_methods
        call = writter? ? :attr_accessor : :attr_reader

        add_method(call, *attributes_names, type: :call)
      end

      # @private
      # Change the method +==+
      #
      # The change happens using {Sinclair::Comparable}
      # and adding all the fields to be included in the comparisom
      #
      # @return [Array<MethodDefinition>]
      def change_equals
        return unless comparable?

        add_method(:include, Comparable, type: :call)
        add_method(:comparable_by, *attributes_names, type: :call)
      end

      # @private
      #
      # Changes the initializer to accept the parameters
      #
      # @return [Array<MethodDefinition>]
      def change_initializer
        lines = attributes_names.map do |attr|
          "@#{attr} = #{attr}"
        end

        lines << 'super(**attributes)'

        code = lines.join("\n")

        add_method(:initialize, code, named_parameters: attributes + ['**attributes'])
      end

      # @private
      # Returns the list of attributes
      #
      # This is used when defining the readers / setters
      #
      # @return [Array<Symbol>]
      def attributes_names
        @attributes_names ||= attributes.map do |attr|
          attr.try(:keys) || attr.to_s
        end.flatten
      end
    end
  end
end
