# frozen_string_literal: true

class Sinclair
  class Options
    # Class Methods for {Sinclair::Options}
    module ClassMethods
      # @api private
      #
      # returns invalid options
      #
      # @return [Array<Symbol>]
      def invalid_options_in(names)
        names.map(&:to_sym) - allowed_options.to_a
      end

      # @api private
      #
      # Allow new option
      #
      # This does not create the method
      #
      # @param name [String,Symbol] options to be allowed
      #
      # @return [Set<Symbol>]
      def allow(name)
        allowed_options << name.to_sym
      end

      # @api private
      # @private
      #
      # Options allowed when initializing options
      #
      # @return [Set<Symbol>]
      def allowed_options
        @allowed_options ||= superclass.try(:allowed_options).dup || Set.new
      end

      # @api private
      #
      # checks if class skips initialization validation
      #
      # @return [TrueClass,FalseClass]
      def skip_validation?
        @skip_validation ||= superclass.try(:skip_validation?) || false
      end

      # @api public
      #
      # Add available options
      #
      # @example (see Options)
      #
      # @return (see Sinclair#build)
      #
      # @overload with_options(*options)
      #   @param options [Array<Symbol>] list of accepted
      #     options
      # @overload with_options(*options, **defaults)
      #   @param options [Array<Symbol>] list of accepted
      #     options
      #   @param defaults [Hash<Symbol,Object>] default options
      #     hash
      def with_options(*options)
        Builder.new(self, *options).build
      end

      # @api public
      #
      # Changes class to skip attributes validation
      #
      # when initializing options, options
      # will accept any arguments when validation
      # is skipped
      #
      # @return [TrueClass]
      #
      # @example
      #   class BuilderOptions < Sinclair::Options
      #     with_options :name
      #
      #     skip_validation
      #   end
      #   options = BuilderOptions.new(name: 'Joe', age: 10)
      #
      #   options.name      # returns 'Joe'
      #   options.try(:age) # returns nil
      def skip_validation
        @skip_validation = true
      end
    end
  end
end
