# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeInstanceMethod < Base
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for ChangeInstanceMethodOn
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which instance the method is being changed on' \
          "change_method(:#{method_name}).on(instance)"
      end

      # Creates a matcher {ChangeInstanceMethodOn}
      #
      # @param target [Class]
      #   class where the method should be change on
      #
      # @return [ChangeInstanceMethodOn] the correct matcher
      def on(target = nil)
        ChangeInstanceMethodOn.new(target, method_name)
      end
    end
  end
end
