# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeClassMethod < Base
      # Creates a matcher {ChangeClassMethodOn}
      #
      # @param target [Class]
      #   class where the method should be change on
      #
      # @return [ChangeClassMethodOn] the correct matcher
      def on(target = nil)
        ChangeClassMethodOn.new(target, method_name)
      end

      private

      def matcher_error
        'You should specify which class the method is being changed on' \
          "change_class_method(:#{method_name}).on(klass)"
      end
    end
  end
end
