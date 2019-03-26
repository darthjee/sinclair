# frozen_string_literal: true

class Sinclair
  # Definition of the code or block to be aded as method
  class MethodDefinition
    # @overload initialize(name, code)
    # @overload initialize(name, &block)
    #
    # @param name  [String,Symbol] name of the method
    # @param code  [String] code to be evaluated as method
    # @param block [Proc] block with code to be added as method
    #
    # @example
    #   Sinclair::Method.new(:name, '@name')
    #
    # @example
    #   Sinclair::Method.new(:name) { @name }
    def initialize(name, code = nil, &block)
      @name = name
      @code = code
      @block = block
    end

    # Adds the method to given klass
    # @param klass [Class] class which will receive the new method
    def build(klass)
      if code.is_a?(String)
        build_code_method(klass)
      else
        build_block_method(klass)
      end
    end

    private

    attr_reader :name, :code, :block

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
