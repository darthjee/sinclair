require 'active_support'
require 'active_support/all'

class ConcernBuilder
  require 'concern_builder/options_parser'

  autoload :VERSION,          'concern_builder/version'
  autoload :MethodDefinition, 'concern_builder/method_definition'

  include OptionsParser

  attr_reader :clazz

  def initialize(clazz, options = {})
    @clazz = clazz
    @options = options
  end

  def build
    definitions.each do |definition|
      definition.build
    end
  end

  def add_method(name, code = nil, &block)
    definitions << MethodDefinition.new(clazz, name, code, &block)
  end

  private

  def definitions
    @definitions ||= []
  end
end
