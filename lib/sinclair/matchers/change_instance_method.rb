# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeInstanceMethod < Base
      include AddMethod

      alias on to

      private

      def matcher_error
        'You should specify which instance the method is being changed on' \
          "change_method(:#{method_name}).on(instance)"
      end

      def add_method_to_class
        ChangeInstanceMethodOn
      end
    end
  end
end
