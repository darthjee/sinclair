# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Helper for wrapping block with cacheing
    module BlockHelper
      module_function

      # @private
      #
      # Returns proc block when {#cached?} as simple
      #
      # @return [Proc]
      def cached_method_proc(method_name, &inner_block)
        proc do
          instance_variable_get("@#{method_name}") ||
            instance_variable_set(
              "@#{method_name}",
              instance_eval(&inner_block)
            )
        end
      end

      # @private
      #
      # Returns proc block when {#cached?} as full
      #
      # @return [Proc]
      def full_cached_method_proc(method_name, &inner_block)
        proc do
          if instance_variable_defined?("@#{method_name}")
            instance_variable_get("@#{method_name}")
          else
            instance_variable_set(
              "@#{method_name}",
              instance_eval(&inner_block)
            )
          end
        end
      end
    end
  end
end
