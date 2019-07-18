# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Definition of the code or block to be aded as method
  class MethodDefinition
    include Sinclair::OptionsParser

    autoload :InstanceMethodDefinition, 'sinclair/method_definition/instance_method_definition'
    autoload :InstanceBlockDefinition,  'sinclair/method_definition/instance_block_definition'
    autoload :InstanceStringDefinition, 'sinclair/method_definition/instance_string_definition'
    autoload :ClassMethodDefinition,    'sinclair/method_definition/class_method_definition'
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

    # Adds the method to given klass
    #
    # This should be implemented on child classes
    #
    # @param _klass [Class] class which will receive the new method
    #
    # @example Using block method with no options
    #   class MyModel
    #   end
    #
    #   instance = MyModel.new
    #
    #   method_definition = Sinclair::MethodDefinition.from(
    #     :sequence, '@x = @x.to_i ** 2 + 1'
    #   )
    #
    #   method_definition.build(klass)  # adds instance_method :sequence to
    #                                  # MyModel instances
    #
    #   instance.instance_variable_get(:@x)        # returns nil
    #
    #   instance.sequence               # returns 1
    #   instance.sequence               # returns 2
    #   instance.sequence               # returns 5
    #
    #   instance.instance_variable_get(:@x)        # returns 5
    #
    # @example Using string method with no options
    #   class MyModel
    #   end
    #
    #   instance = MyModel.new
    #
    #   method_definition = Sinclair::MethodDefinition.from(:sequence) do
    #     @x = @x.to_i ** 2 + 1
    #   end
    #
    #   method_definition.build(klass)  # adds instance_method :sequence to
    #                                  # MyModel instances
    #
    #   instance.instance_variable_get(:@sequence) # returns nil
    #   instance.instance_variable_get(:@x)        # returns nil
    #
    #   instance.sequence               # returns 1
    #   instance.sequence               # returns 1 (cached value)
    #
    #   instance.instance_variable_get(:@sequence) # returns 1
    #   instance.instance_variable_get(:@x)        # returns 1
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
