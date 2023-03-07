# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    include Sinclair::OptionsParser

    autoload :BlockHelper,      'sinclair/method_definition/block_helper'
    autoload :BlockDefinition,  'sinclair/method_definition/block_definition'
    autoload :StringDefinition, 'sinclair/method_definition/string_definition'
    autoload :CallDefinition,   'sinclair/method_definition/call_definition'

    # @method name
    #
    # name of the method
    #
    # @return [String,Symbol]
    attr_reader :name

    # Default options of initialization
    DEFAULT_OPTIONS = {
      cached: false
    }.freeze

    class << self
      # Builds a method that will return the same value always
      #
      # @return [Symbol]
      def default_value(method_name, value)
        define_method(method_name) { value }
      end

      # @param name    [String,Symbol] name of the method
      # @param code    [String] code to be evaluated as method
      # @param block   [Proc] block with code to be added as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create a block
      #   with cache
      #
      # builds a method definition based on arguments
      #
      # when block is given, returns a {BlockDefinition} and
      # returns a {StringDefinition} otherwise
      #
      # @return [Base]
      def from(name, code = nil, **options, &block)
        if block
          BlockDefinition.new(name, **options, &block)
        else
          StringDefinition.new(name, code, **options)
        end
      end

      # creates a definition
      #
      # The creation is based on type which will be used to infer
      # which subclass of {Sinclair::MethodDefinition} to be used
      #
      # @param type [Symbol] the method definition type
      #
      # @return [Sinclair::MethodDefinition] an instance of a subclass
      def for(type, *args, **options, &block)
        klass = const_get("#{type}_definition".camelize)
        klass.new(*args, **options, &block)
      end

      def build_with(builder_class)
        define_method(:build) do |klass, type|
          builder_class.build(klass, self, type: type)
        end
      end
    end

    # @param name    [String,Symbol] name of the method
    # @param options [Hash] Options of construction
    # @option options cached [Boolean] Flag telling to create
    #   a method with cache
    def initialize(name, **options)
      @name =    name
      @options = DEFAULT_OPTIONS.merge(options)
    end

    # @abstract
    #
    # Adds the method to given klass
    #
    # This should be implemented on child classes
    #
    # @param _klass [Class] class which will receive the new method
    #
    # @example (see MethodDefinition::StringDefinition#build)
    # @example (see MethodDefinition::BlockDefinition#build)
    #
    # @return [Symbol] name of the created method
    def build(_klass)
      fail 'Build is implemented in subclasses. ' \
        "Use #{self.class}.from to initialize a proper object"
    end

    delegate :cached, to: :options_object

    # @private
    #
    # Flag telling to use cached method
    #
    # @return [Boolean]
    alias cached? cached
  end
end
