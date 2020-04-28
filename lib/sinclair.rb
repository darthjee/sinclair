# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

# @api public
# @author darthjee
#
# Builder that add instance methods to a class
#
# @example Stand alone usage
#   class MyModel
#   end
#
#   buider = Sinclair.new(MyModel)
#
#   value = 10
#   builder.add_method(:default_value) { value }
#   builder.add_method(:value, '@value || default_value')
#   builder.add_method(:value=) { |val| @value = val }
#   builder.build
#
#   instance = MyModel.new
#   instance.value # returns 10
#   instance.value = 20
#   instance.value # returns 20
#
# @example Using cache
#   module DefaultValueable
#     def default_reader(*methods, value:, accept_nil: false)
#       DefaultValueBuilder.new(
#         self, value: value, accept_nil: accept_nil
#       ).add_default_values(*methods)
#     end
#   end
#
#   class DefaultValueBuilder < Sinclair
#     def add_default_values(*methods)
#       default_value = value
#
#       methods.each do |method|
#         add_method(method, cached: cache_type) { default_value }
#       end
#
#       build
#     end
#
#     private
#
#     delegate :accept_nil, :value, to: :options_object
#
#     def cache_type
#       accept_nil ? :full : :simple
#     end
#   end
#
#   class Server
#     extend DefaultValueable
#
#     attr_writer :host, :port
#
#     default_reader :host, value: 'server.com', accept_nil: false
#     default_reader :port, value: 80,           accept_nil: true
#
#     def url
#       return "http://#{host}" unless port
#
#       "http://#{host}:#{port}"
#     end
#   end
#   server = Server.new
#
#   server.url # returns 'http://server.com:80'
#
#   server.host = 'interstella.com'
#   server.port = 5555
#   server.url # returns 'http://interstella.com:5555'
#
#   server.host = nil
#   server.port = nil
#   server.url # return 'http://server.com'
class Sinclair
  require 'sinclair/options_parser'

  autoload :VERSION,           'sinclair/version'
  autoload :Config,            'sinclair/config'
  autoload :ConfigBuilder,     'sinclair/config_builder'
  autoload :ConfigClass,       'sinclair/config_class'
  autoload :ConfigFactory,     'sinclair/config_factory'
  autoload :Configurable,      'sinclair/configurable'
  autoload :EnvSettable,       'sinclair/env_settable'
  autoload :Exception,         'sinclair/exception'
  autoload :MethodBuilder,     'sinclair/method_builder'
  autoload :MethodDefinition,  'sinclair/method_definition'
  autoload :MethodDefinitions, 'sinclair/method_definitions'
  autoload :Options,           'sinclair/options'

  include OptionsParser

  # Returns a new instance of Sinclair
  #
  # @param klass [Class] Class that will receive the methods
  # @param options [Hash] open hash options to be used by builders inheriting from Sinclair
  #   through the Sinclair::OptionsParser concern
  #
  # @example Preparing builder
  #
  #   class Purchase
  #     def initialize(value, quantity)
  #       @value = value
  #       @quantity = quantity
  #     end
  #   end
  #
  #   builder = Sinclair.new(Purchase)
  #
  # @example Passing building options (Used on subclasses)
  #
  #   class MyBuilder < Sinclair
  #     def add_methods
  #       if options_object.rescue_error
  #         add_safe_method
  #       else
  #         add_method(:symbolize) { @variable.to_sym }
  #       end
  #     end
  #
  #     def add_safe_method
  #       add_method(:symbolize) do
  #         begin
  #           @variable.to_sym
  #         rescue StandardError
  #           :default
  #         end
  #       end
  #     end
  #   end
  #
  #   class MyModel
  #   end
  #
  #   builder = MyBuilder.new(MyModel, rescue_error: true)
  #
  #   builder.add_method
  #   builder.build
  #
  #   instance = MyModel.new
  #
  #   instance.symbolize # returns :default
  def initialize(klass, options = {})
    @klass = klass
    @options = options
  end

  # builds all the methods added into the klass
  #
  # @example Adding a default value method
  #
  #   class MyModel
  #   end
  #
  #   buider = Sinclair.new(MyModel)
  #
  #   builder.add_method(:default_value) { value }
  #
  #   MyModel.new.respond_to(:default_value) # returns false
  #
  #   builder.build
  #
  #   MyModel.new.respond_to(:default_value) # returns true
  #
  # @return [Array<MethodDefinition>]
  def build
    builder.build_methods(definitions, MethodBuilder::INSTANCE_METHOD)
    builder.build_methods(class_definitions, MethodBuilder::CLASS_METHOD)
  end

  # Add a method to the method list to be created on klass instances
  #
  # @param name [String,Symbol] name of the method to be added
  # @param options [Hash] Options of construction
  # @option options cached [Boolean] Flag telling to create
  #   a method with cache
  #
  # @overload add_method(name, code, **options)
  #   @param code [String] code to be evaluated when the method is ran
  #
  # @overload add_method(name, **options, &block)
  #   @param block [Proc]  block to be ran as method
  #
  # @example Using string code
  #   class Person
  #     attr_reader :first_name, :last_name
  #
  #     def initialize(first_name, last_name)
  #       @first_name = first_name
  #       @last_name = last_name
  #     end
  #   end
  #
  #   builder = Sinclair.new(Person)
  #   builder.add_method(:full_name, '[first_name, last_name].join(" ")')
  #   builder.build
  #
  #   Person.new('john', 'wick').full_name # returns 'john wick'
  #
  # @example Using block
  #   class Person
  #     attr_reader :first_name, :last_name
  #
  #     def initialize(first_name, last_name)
  #       @first_name = first_name
  #       @last_name = last_name
  #     end
  #   end
  #
  #   builder = Sinclair.new(Person)
  #   builder.add_method(:full_name, '[first_name, last_name].join(" ")')
  #   builder.add_method(:bond_name) { "#{last_name}, #{full_name}" }
  #   builder.build
  #
  #   Person.new('john', 'wick').bond_name # returns 'wick, john wick'
  # @return [Array<MethodDefinition>]
  def add_method(name, code = nil, **options, &block)
    definitions.add(
      name, code, **options, &block
    )
  end

  # Add a method to the method list to be created on klass
  #
  # @param name [String,Symbol] name of the method to be added
  # @param options [Hash] Options of construction
  # @option options cached [Boolean] Flag telling to create
  #   a method with cache
  #
  # @overload add_class_method(name, code, **options)
  #   @param code [String] code to be evaluated when the method is ran
  #
  # @overload add_class_method(name, **options, &block)
  #   @param block [Proc]  block to be ran as method
  #
  # @example
  #   class EnvFetcher
  #   end
  #
  #   builder = Sinclair.new(EnvFetcher)
  #
  #   builder.add_class_method(:hostname, 'ENV["HOSTNAME"]')
  #   builder.build
  #
  #   ENV['HOSTNAME'] = 'myhost'
  #
  #   env_fetcher.hostname # returns 'myhost'
  #
  # @example
  #   class EnvFetcher
  #   end
  #
  #   builder = Sinclair.new(EnvFetcher)
  #
  #   builder.add_class_method(:timeout) { ENV['TIMEOUT'] }
  #   builder.build
  #
  #   ENV['TIMEOUT'] = '300'
  #
  #   env_fetcher.timeout # returns '300'
  #
  # @return [Array<MethodDefinition>]
  def add_class_method(name, code = nil, **options, &block)
    class_definitions.add(
      name, code, **options, &block
    )
  end

  # Evaluetes a block which will result in a String, the method code
  #
  # @example Building a initial value class method
  #
  #   module InitialValuer
  #     extend ActiveSupport::Concern
  #
  #     class_methods do
  #       def initial_value_for(attribute, value)
  #         builder = Sinclair.new(self, initial_value: value)
  #         builder.eval_and_add_method(attribute) do
  #           "@#{attribute} ||= #{options_object.initial_value}"
  #         end
  #         builder.build
  #       end
  #     end
  #   end
  #
  #   class MyClass
  #     include InitialValuer
  #     attr_writer :age
  #     initial_value_for :age, 20
  #   end
  #
  #   object = MyClass.new
  #   object.age # 20
  #   object.age = 30
  #   object.age # 30
  #
  # @example Adding option for rescue
  #
  #   class Purchase
  #     def initialize(value, quantity)
  #       @value = value
  #       @quantity = quantity
  #     end
  #   end
  #
  #   builder = Sinclair.new(Purchase)
  #
  #   builder.eval_and_add_method(:total_price) do
  #     code = 'self.value * self.quantity'
  #     code.concat ' rescue 0' if options_object.rescue_error
  #     code
  #   end
  #
  #   builder.build
  #
  #   Purchase.new(2.3, 5).total_price # raises error
  #
  # @example Using option for rescue
  #
  #   builder = Sinclair.new(Purchase, rescue_error: true)
  #
  #   builder.eval_and_add_method(:total_price) do
  #     code = 'self.value * self.quantity'
  #     code.concat ' rescue 0' if options_object.rescue_error
  #     code
  #   end
  #
  #   builder.build
  #
  #   Purchase.new(2.3, 5).total_price # returns 0
  #
  #   class Purchase
  #     attr_reader :value, :quantity
  #   end
  #
  #   Purchase.new(2.3, 5).total_price # returns 11.5
  # @return [Array<MethodDefinition>]
  def eval_and_add_method(name, &block)
    add_method(name, instance_eval(&block))
  end

  private

  attr_reader :klass
  # @method klass
  # @api private
  # @private
  #
  # Class that will receive the methods
  #
  # @return [Class]

  # @private
  # @api private
  #
  # List of instance method definitions
  #
  # @return [MethodDefinitions]
  def definitions
    @definitions ||= MethodDefinitions.new
  end

  # @private
  # @api private
  #
  # List of class method definitions
  #
  # @return [MethodDefinitions]
  def class_definitions
    @class_definitions ||= MethodDefinitions.new
  end

  # @private
  # @api private
  #
  # MethodBuilder binded to the class
  #
  # @return [MethodBuilder]
  def builder
    @builder ||= MethodBuilder.new(klass)
  end
end
