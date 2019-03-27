# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    include Sinclair::OptionsParser
    # Default options of initialization
    DEFAULT_OPTIONS = {
      cached: false
    }.freeze

    # Returns a new instance of MethodDefinition
    #
    # @overload initialize(name, code)
    #   @example
    #     Sinclair::MethodDefinition.new(:name, '@name')
    #
    # @overload initialize(name, &block)
    #   @example
    #     Sinclair::MethodDefinition.new(:name) { @name }
    #
    # @param name    [String,Symbol] name of the method
    # @param code    [String] code to be evaluated as method
    # @param block   [Proc] block with code to be added as method
    # @param options [Hash] Options of construction
    # @option options cached [Boolean] Flag telling to create
    #   a method with cache
    def initialize(name, code = nil, **options, &block)
      @name =    name
      @code =    code
      @options = DEFAULT_OPTIONS.merge(options)
      @block =   block
    end

    # Adds the method to given klass
    #
    # @param klass [Class] class which will receive the new method
    # 
    # @example Using string method with no options
    #   class MyModel
    #   end
    #
    #   instance = MyModel.new
    #
    #   method_definition = Sinclair::MethodDefinition.new(
    #     :sequence, '@x = @x.to_i ** 2 + 1'
    #   )
    #
    #  method_definition.build(klass)  # adds instance_method :sequence to
    #                                  # MyModel instances
    #
    #  instance.sequence               # returns 1
    #  instance.sequence               # returns 2
    #  instance.sequence               # returns 5
    #
    # @example Using string method with no options
    #   class MyModel
    #   end
    #
    #   instance = MyModel.new
    #
    #   method_definition = Sinclair::MethodDefinition.new(:sequence) do
    #     @x = @x.to_i ** 2 + 1
    #   end
    #
    #  method_definition.build(klass)  # adds instance_method :sequence to
    #                                  # MyModel instances
    #
    #  instance.sequence               # returns 1
    #  instance.sequence               # returns 1 (cached value)
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
    delegate :cached, to: :options_object

    # @private
    #
    # Flag telling to use cached method
    #
    # @return [Boolean]
    alias cached? cached

    # @private
    #
    # Add method from block
    #
    # @return [Symbol] name of the created method
    def build_block_method(klass)
      klass.send(:define_method, name, method_block)
    end

    # @private
    #
    # Returns the block that will be used for method creattion
    #
    # @return [Proc]
    def method_block
      return block unless cached?

      inner_block = block
      method_name = name

      proc do |*args|
        instance_variable_get("@#{method_name}") ||
          instance_variable_set(
            "@#{method_name}",
            inner_block.call(*args)
          )
      end
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
      code_line = cached? ? "@#{name} ||= #{code}" : code
      <<-CODE
      def #{name}
        #{code_line}
      end
      CODE
    end
  end
end
