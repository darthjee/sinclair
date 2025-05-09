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
#   value = 10
#
#   Sinclair.build(MyModel) do
#     add_method(:default_value) { value }
#     add_method(:value, '@value || default_value')
#     add_method(:value=) { |val| @value = val }
#   end
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
  autoload :Caster,            'sinclair/caster'
  autoload :ClassMethods,      'sinclair/class_methods'
  autoload :ChainSettable,     'sinclair/chain_settable'
  autoload :Config,            'sinclair/config'
  autoload :ConfigBuilder,     'sinclair/config_builder'
  autoload :ConfigClass,       'sinclair/config_class'
  autoload :ConfigFactory,     'sinclair/config_factory'
  autoload :Configurable,      'sinclair/configurable'
  autoload :Comparable,        'sinclair/comparable'
  autoload :EnvSettable,       'sinclair/env_settable'
  autoload :Exception,         'sinclair/exception'
  autoload :EqualsChecker,     'sinclair/equals_checker'
  autoload :InputHash,         'sinclair/input_hash'
  autoload :MethodBuilder,     'sinclair/method_builder'
  autoload :MethodDefinition,  'sinclair/method_definition'
  autoload :MethodDefinitions, 'sinclair/method_definitions'
  autoload :Model,             'sinclair/model'
  autoload :Options,           'sinclair/options'
  autoload :Settable,          'sinclair/settable'

  include OptionsParser
  extend ClassMethods

  # @method self.build(klass, options = {}, &block)
  # @api public
  #
  # Runs build using a block for adding the methods
  #
  # The block is executed adding the methods and after the builder
  # runs build building all the methods
  #
  # @see Sinclair::ClassMethods#build
  #
  # @param (see Sinclair::ClassMethods#build)
  # @return (see Sinclair::ClassMethods#build)
  # @yield (see Sinclair::ClassMethods#build)
  #
  # @example (see Sinclair::ClassMethods#build)

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
  #   MyBuilder.build(MyModel, rescue_error: true) do
  #     add_method
  #   end
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
  # @see MethodDefinitions#add
  #
  # @overload add_method(name, code, **options)
  #   @param name [String,Symbol] name of the method to be added
  #   @param code [String] code to be evaluated when the method is ran
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #   @see MethodDefinition::StringDefinition
  #
  #   @example Using string code to add a string defined method
  #     class Person
  #       attr_accessor :first_name, :last_name
  #
  #       def initialize(first_name, last_name)
  #         @first_name = first_name
  #         @last_name = last_name
  #       end
  #     end
  #
  #     Sinclair.build(Person) do
  #       add_method(:full_name, '[first_name, last_name].join(" ")')
  #     end
  #
  #     Person.new('john', 'wick').full_name # returns 'john wick'
  #
  # @overload add_method(name, **options, &block)
  #   @param name [String,Symbol] name of the method to be added
  #   @param block [Proc]  block to be ran as method
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #   @see MethodDefinition::BlockDefinition
  #
  #   @example Using block to add a block method
  #     class Person
  #       attr_accessor :first_name, :last_name
  #
  #       def initialize(first_name, last_name)
  #         @first_name = first_name
  #         @last_name = last_name
  #       end
  #     end
  #
  #     Sinclair.build(Person) do
  #       add_method(:bond_name) { "#{last_name}, #{first_name} #{last_name}" }
  #     end
  #
  #     Person.new('john', 'wick').bond_name # returns 'wick, john wick'
  #
  # @overload add_method(*args, type:, **options, &block)
  #   @param args [Array<Object>] arguments to be passed to the definition
  #   @param type [Symbol] type of method definition
  #   @param block [Proc]  block to be ran as method when type is block
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #   @see MethodDefinition::BlockDefinition
  #   @see MethodDefinition::StringDefinition
  #   @see MethodDefinition::CallDefinition
  #
  #   @example Passing type block
  #     class Person
  #       attr_accessor :first_name, :last_name
  #
  #       def initialize(first_name, last_name)
  #         @first_name = first_name
  #         @last_name = last_name
  #       end
  #     end
  #
  #     Sinclair.build(Person) do
  #       add_method(:bond_name, type: :block, cached: true) do
  #         "{last_name}, #{first_name} #{last_name}"
  #       end
  #     end
  #
  #     person.Person.new('john', 'wick')
  #
  #     person.bond_name # returns 'wick, john wick'
  #     person.first_name = 'Johny'
  #     person.bond_name # returns 'wick, john wick'
  #
  #   @example Passing type call
  #     class Person
  #     end
  #
  #     builder = Sinclair.new(Person)
  #     builder.add_method(:attr_accessor, :bond_name, type: :call)
  #     builder.build
  #
  #     person.bond_name = 'Bond, James Bond'
  #     person.bond_name # returns 'Bond, James Bond'
  #
  # @return [Array<MethodDefinition>] the list of all currently defined instance methods
  def add_method(*, type: nil, **, &)
    definitions.add(*, type:, **, &)
  end

  # Add a method to the method list to be created on klass
  # @see MethodDefinitions#add
  #
  # @overload add_class_method(name, code, **options)
  #   @param name [String,Symbol] name of the method to be added
  #   @param code [String] code to be evaluated when the method is ran
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #
  #   @example Adding a method by String
  #     class EnvFetcher
  #     end
  #
  #     builder = Sinclair.new(EnvFetcher)
  #
  #     builder.add_class_method(:hostname, 'ENV["HOSTNAME"]')
  #     builder.build
  #
  #     ENV['HOSTNAME'] = 'myhost'
  #
  #     EnvFetcher.hostname # returns 'myhost'
  #
  # @overload add_class_method(name, **options, &block)
  #   @param name [String,Symbol] name of the method to be added
  #   @param block [Proc]  block to be ran as method
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #
  #   @example Adding a method by Block
  #     class EnvFetcher
  #     end
  #
  #     builder = Sinclair.new(EnvFetcher)
  #
  #     builder.add_class_method(:timeout) { ENV['TIMEOUT'] }
  #     builder.build
  #
  #     ENV['TIMEOUT'] = '300'
  #
  #     EnvFetcher.timeout # returns '300'
  #
  # @overload add_class_method(*args, type: **options, &block)
  #   @param args [Array<Object>] arguments to be passed to the definition
  #   @param type [Symbol] type of method definition
  #   @param block [Proc]  block to be ran as method when type is block
  #   @param options [Hash] Options of construction
  #   @option options cached [Boolean] Flag telling to create
  #     a method with cache
  #   @see MethodDefinition::BlockDefinition
  #   @see MethodDefinition::StringDefinition
  #   @see MethodDefinition::CallDefinition
  #
  #   @example Passing type block
  #     class EnvFetcher
  #     end
  #
  #     builder = Sinclair.new(EnvFetcher)
  #
  #     builder.add_class_method(:timeout, type: :block) { ENV['TIMEOUT'] }
  #     builder.build
  #
  #     ENV['TIMEOUT'] = '300'
  #
  #     EnvFetcher.timeout # returns '300'
  #
  #   @example Passing type call
  #     class EnvFetcher
  #     end
  #
  #     builder = Sinclair.new(EnvFetcher)
  #
  #     builder.add_class_method(:attr_accessor, :timeout, type: :call)
  #     builder.build
  #
  #     EnvFetcher.timeout = 10
  #
  #     env_fetcher.timeout # returns '10'
  #
  # @return [Array<MethodDefinition>] the list of all currently defined class methods
  def add_class_method(*, type: nil, **, &)
    class_definitions.add(*, type:, **, &)
  end

  # Evaluetes a block which will result in a String, the method code
  #
  # @example Building a initial value class method
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
  #
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
  # @return [Array<MethodDefinition>] the list of all currently defined instance methods
  def eval_and_add_method(name, &)
    add_method(name, instance_eval(&))
  end

  private

  # @!visibility public
  # @api private
  # @private
  #
  # Class that will receive the methods
  #
  # @return [Class]
  attr_reader :klass

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
