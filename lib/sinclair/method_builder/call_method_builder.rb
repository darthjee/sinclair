# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    class CallMethodBuilder < Base
      def build
        klass.module_eval(code_line, __FILE__, __LINE__ + 1)
      end

      private

      def code_line
        instance? ? code_string : class_code_string
      end

      delegate :code_string, :class_code_string, to: :definition
    end
  end
end
