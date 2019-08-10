class Sinclair
  class MethodBuilder
    autoload :StringMethodBuilder, 'sinclair/method_builder/string_method_builder'
    autoload :BlockMethodBuilder,  'sinclair/method_builder/block_method_builder'

    def initialize(klass)
      @klass = klass
    end

    def build_method(definition)
      if definition.string?
        string_method_builder.build_method(definition)
      else
        block_method_builder.build_method(definition)
      end
    end

    def build_class_method(definition)
      if definition.string?
        string_method_builder.build_class_method(definition)
      else
        block_method_builder.build_class_method(definition)
      end
    end

    private

    attr_reader :klass

    def string_method_builder
      @string_method_builder ||= StringMethodBuilder.new(klass)
    end

    def block_method_builder
      @block_method_builder ||= BlockMethodBuilder.new(klass)
    end
  end
end
