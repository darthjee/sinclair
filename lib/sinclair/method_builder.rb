class Sinclair
  class MethodBuilder
    autoload :StringMethodBuilder, 'sinclair/method_builder/string_method_builder'

    def initialize(klass)
      @klass = klass
    end

    def build_method(definition)
      string_method_builder.build_method(definition)
    end

    def build_class_method(definition)
      string_method_builder.build_class_method(definition)
    end

    private

    attr_reader :klass

    def string_method_builder
      @string_method_builder ||= StringMethodBuilder.new(klass)
    end
  end
end
