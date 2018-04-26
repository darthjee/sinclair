class ConcernBuilder::MethodDefinition
  attr_reader :clazz, :name, :code, :block

  def initialize(clazz, name, code = nil, &block)
    @clazz = clazz
    @name = name
    @code = code
    @block = block
  end

  def build
    if code.is_a?(String)
      build_code_method
    else
      build_block_method
    end
  end

  private

  def build_block_method
    clazz.send(:define_method, name, block)
  end

  def build_code_method
    clazz.module_eval(code_definition, __FILE__, __LINE__ + 1)
  end

  def code_definition
    <<-CODE
      def #{name}
        #{code}
      end
    CODE
  end
end
