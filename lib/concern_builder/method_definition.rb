class ConcernBuilder::MethodDefinition
  attr_reader :name, :code, :block

  def initialize(name, code = nil, &block)
    @name = name
    @code = code
    @block = block
  end

  def build(clazz)
    if code.is_a?(String)
      build_code_method(clazz)
    else
      build_block_method(clazz)
    end
  end

  private

  def build_block_method(clazz)
    clazz.send(:define_method, name, block)
  end

  def build_code_method(clazz)
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
