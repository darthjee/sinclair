# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    include Sinclair::OptionsParser

    autoload :InstanceMethodDefinition, 'sinclair/method_definition/instance_method_definition'
    autoload :ClassMethodDefinition,    'sinclair/method_definition/class_method_definition'
    autoload :BlockDefinition,          'sinclair/method_definition/block_definition'
    autoload :StringDefinition,         'sinclair/method_definition/string_definition'
    autoload :InstanceBlockDefinition,  'sinclair/method_definition/instance_block_definition'
    autoload :InstanceStringDefinition, 'sinclair/method_definition/instance_string_definition'
    autoload :ClassBlockDefinition,     'sinclair/method_definition/class_block_definition'
    autoload :ClassStringDefinition,    'sinclair/method_definition/class_string_definition'

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

    def self.default_value(method_name, value)
      self.define_method(method_name) { value }
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
      raise 'Build is implemented in subclasses. ' \
        "Use #{self.class}.from to initialize a proper object"
    end

    private

    delegate :cached, to: :options_object

    # @private
    #
    # Flag telling to use cached method
    #
    # @return [Boolean]
    alias cached? cached
  end
end
