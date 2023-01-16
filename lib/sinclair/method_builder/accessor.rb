# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Class responsible to build attr_accessor, reader or writer methods
    class Accessor < Base
      # @param klass [Class] class to receive the method
      # @param type [Symbol] type of method to be build
      #   - +:instance+ instance methods
      #   - +:class+ class methods
      def initialize(klass, *attributes, type:, accessor_type: :accessor)
        @klass         = klass
        @attributes    = attributes.flatten
        @type          = type
        @accessor_type = accessor_type
      end

      # Builds the accessors
      #
      # @return [NilClass]
      def build
        if instance?
          klass.module_eval(code_string)
        else
          klass.module_eval(class_code_string)
        end
      end

      private

      attr_reader :attributes, :accessor_type

      # @method attributes
      # @api private
      # @private
      #
      # Attributes to be added as accessors
      #
      # @return [Array<Symbol>]

      # @method accessor_type
      # @api private
      # @private
      #
      # Type of accessor
      #
      # The options are
      # - acessor: both reader and writer will be built
      # - reader: only the reader will be built
      # - writer: only the writer will be built
      #
      # @return [Symbol]

      # String that adds the accessor
      #
      # @return [String]
      def code_string
        "attr_#{accessor_type} :#{attributes.join(', :')}"
      end

      # String that adds the accessor to a class
      #
      # @return [String]
      def class_code_string
        <<-CODE
          class << self
            #{code_string}
          end
        CODE
      end
    end
  end
end
