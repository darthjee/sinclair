# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    # Returns a new instance of MethodDefinition
    #
    # @overload initialize(name, code)
    # @overload initialize(name, &block)
    #
    # @param name  [String,Symbol] name of the method
    # @param code  [String] code to be evaluated as method
    # @param block [Proc] block with code to be added as method
    #
    # @example
    #   Sinclair::MethodDefinition.new(:name, '@name')
    #
    # @example
    #   Sinclair::MethodDefinition.new(:name) { @name }
    def initialize(name, code = nil, **_options, &block)
      @name = name
      @code = code
      @block = block
    end

    # Adds the method to given klass
    #
    # @param klass [Class] class which will receive the new method
    #
    # @return [Symbol] name of the created method
    def build(klass)
      if code.is_a?(String)
        build_code_method(klass)
      else
        build_block_method(klass)
      end
    end

    private

    # @private
    attr_reader :name, :code, :block

    # @private
    #
    # Add method from block
    #
    # @return [Symbol] name of the created method
    def build_block_method(klass)
      klass.send(:define_method, name, block)
    end

    # @private
    #
    # Add method from String code
    #
    # @return [Symbol] name of the created method
    def build_code_method(klass)
      klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
    end

    # @private
    #
    # Builds full code of method
    #
    # @return [String]
    def code_definition
      <<-CODE
      def #{name}
        #{code}
      end
      CODE
    end
  end
end
