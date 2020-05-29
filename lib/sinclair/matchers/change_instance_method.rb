# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeInstanceMethod < Base
      # Creates a matcher {ChangeInstanceMethodOn}
      #
      # @param target [Class]
      #   class where the method should be change on
      #
      # @return [ChangeInstanceMethodOn] the correct matcher
      def on(target = nil)
        ChangeInstanceMethodOn.new(target, method_name)
      end

      private

      def matcher_error
        'You should specify which instance the method is being changed on' \
          "change_method(:#{method_name}).on(instance)"
      end
    end
  end
end
