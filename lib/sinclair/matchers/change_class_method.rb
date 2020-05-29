# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeClassMethod < Base
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for ChangeClassMethodOn
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which class the method is being changed on' \
          "change_class_method(:#{method_name}).on(klass)"
      end

      # Creates a matcher {ChangeClassMethodOn}
      #
      # @param target [Class]
      #   class where the method should be change on
      #
      # @return [ChangeClassMethodOn] the correct matcher
      def on(target = nil)
        ChangeClassMethodOn.new(target, method_name)
      end
    end
  end
end
