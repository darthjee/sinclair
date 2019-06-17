# frozen_string_literal: true

require 'active_support'
require 'active_support/all'

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
# @example Usin cache
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

  autoload :VERSION,          'sinclair/version'
  autoload :MethodDefinition, 'sinclair/method_definition'
  autoload :Config,           'sinclair/config'
  autoload :ConfigBuilder,    'sinclair/config_builder'
  autoload :ConfigFactory,    'sinclair/config_factory'
  autoload :Configurable,     'sinclair/configurable'

  include OptionsParser

  # Returns a new instance of Sinclair
  #
  # @param klass [Class] to receive the methods
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
    definitions.each do |definition|
      definition.build(klass)
    end
  end

  # add a method to the method list to be created on klass
  #
  # @overload add_method(name, code)
  #   @param name [String,Symbol] name of the method to be added
  #   @param code [String] code to be evaluated when the method is ran
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
  # @overload add_method(name, &block)
  #   @param name [String,Symbol] name of the method to be added
  #   @param block [Proc]  block to be ran as method
  #
  # @example Using block
  #   builder = Sinclair.new(Person)
  #   builder.add_method(:bond_name) { "#{last_name}, #{full_name}" }
  #   builder.build
  #
  #   Person.new('john', 'wick').bond_name # returns 'wick, john wick'
  # @return [Array<MethodDefinition>]
  def add_method(name, code = nil, **options, &block)
    definitions << MethodDefinition.from(name, code, **options, &block)
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

  # @api private
  # @private
  attr_reader :klass

  # @private
  #
  # @api private
  #
  # List of mthod definitions
  #
  # @return [Array<MethodDefinition>]
  def definitions
    @definitions ||= []
  end
end
