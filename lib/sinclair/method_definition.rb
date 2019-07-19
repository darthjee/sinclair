# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    include Sinclair::OptionsParser

    autoload :BlockDefinition,          'sinclair/method_definition/block_definition'
    autoload :StringDefinition,         'sinclair/method_definition/string_definition'
    autoload :InstanceBlockDefinition,  'sinclair/method_definition/instance_block_definition'
    autoload :InstanceStringDefinition, 'sinclair/method_definition/instance_string_definition'
    autoload :ClassBlockDefinition,     'sinclair/method_definition/class_block_definition'
    autoload :ClassStringDefinition,    'sinclair/method_definition/class_string_definition'

    # Default options of initialization
    DEFAULT_OPTIONS = {
      cached: false
    }.freeze

    # Creates a new instance based on arguments
    #
    # @return [MethodDefinition] When block is given, a
    #   new instance of {InstanceBlockDefinition} is returned,
    #   otherwise {InstanceStringDefinition} is returned
    def self.from(name, code = nil, **options, &block)
      if block
        InstanceBlockDefinition.new(name, **options, &block)
      else
        InstanceStringDefinition.new(name, code, **options)
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
      raise 'Build is implemented in subclasses. ' \
        "Use #{self.class}.from to initialize a proper object"
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
  end
end
