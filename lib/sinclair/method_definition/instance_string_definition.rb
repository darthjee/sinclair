# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from string
    class InstanceStringDefinition < InstanceMethodDefinition
      # @param name    [String,Symbol] name of the method
      # @param code    [String] code to be evaluated as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      def initialize(name, code = nil, **options)
        @code = code
        super(name, **options)
      end

      # Adds the method to given klass
      #
      # @param klass [Class] class which will receive the new method
      #
      # @see MethodDefinition#build
      #
      # @return [Symbol] name of the created method
      #
      # @example Using instance block method with options
      #   class MyModel
      #   end
      #
      #   instance = MyModel.new
      #
      #   method_definition = Sinclair::MethodDefinition::InstanceStringDefinition.new(
      #     :sequence, '@x = @x.to_i ** 2 + 1'
      #   )
      #
      #   method_definition.build(MyModel)    # adds instance_method :sequence to
      #                                       # MyModel instances
      #
      #   instance.instance_variable_get(:@x) # returns nil
      #
      #   instance.sequence                   # returns 1
      #   instance.sequence                   # returns 2
      #   instance.sequence                   # returns 5
      #
      #   instance.instance_variable_get(:@x) # returns 5
      #
      def build(klass)
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      private

      # @private
      #
      # Builds full code of method
      #
      # @return [String]
      def code_definition
        code_line = cached? ? code_with_cache : code

        <<-CODE
          def #{name}
            #{code_line}
          end
        CODE
      end

      # @private
      #
      # Returns string code when {#cached?}
      #
      # @return [String]
      def code_with_cache
        case cached
        when :full
          "defined?(@#{name}) ? @#{name} : (@#{name} = #{code})"
        else
          "@#{name} ||= #{code}"
        end
      end
    end
  end
end
