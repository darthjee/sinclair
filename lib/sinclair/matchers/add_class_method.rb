# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of {Sinclair::Matchers::AddClassMethodTo}
    class AddClassMethod < AddMethod
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for AddClassMethodTo
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which class the method is being added to' \
          "add_class_method(:#{method}).to(klass)"
      end

      # Creates a matcher AddClassMethodTo
      #
      # @param [Class] klass
      #   class where the method should be added to
      #
      # @return [AddClassMethodTo] the correct matcher
      def to(target = nil)
        AddClassMethodTo.new(target, method)
      end
    end
  end
end
