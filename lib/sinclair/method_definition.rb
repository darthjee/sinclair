class Sinclair
  class MethodDefinition
    attr_reader :name, :code, :block

    def initialize(name, code = nil, &block)
      @name = name
      @code = code
      @block = block
    end

    def build(klass)
      if code.is_a?(String)
        build_code_method(klass)
      else
        build_block_method(klass)
      end
    end

    private

    def build_block_method(klass)
      klass.send(:define_method, name, block)
    end

    def build_code_method(klass)
      klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
    end

    def code_definition
      <<-CODE
      def #{name}
        #{code}
      end
      CODE
    end
  end
end
