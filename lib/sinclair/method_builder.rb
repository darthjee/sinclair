class Sinclair
  class MethodBuilder
    def initialize(klass)
      @klass = klass
    end

    def build_method(definition)
      code_definition = <<-CODE
        def #{definition.name}
          #{definition.code_line}
        end
      CODE
      klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
    end

    def build_class_method(definition)
      code_definition = <<-CODE
        def self.#{definition.name}
          #{definition.code_line}
        end
      CODE
      klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
    end

    private

    attr_reader :klass
  end
end
