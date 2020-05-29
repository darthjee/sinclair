# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeClassMethod < Base
      include AddMethod

      alias on to

      private

      def matcher_error
        'You should specify which class the method is being changed on' \
          "change_class_method(:#{method_name}).on(klass)"
      end

      def add_method_to_class
        ChangeClassMethodOn
      end
    end
  end
end
