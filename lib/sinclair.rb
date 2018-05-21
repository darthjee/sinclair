require 'active_support'
require 'active_support/all'

class Sinclair
  require 'sinclair/options_parser'

  autoload :VERSION,          'sinclair/version'
  autoload :MethodDefinition, 'sinclair/method_definition'

  include OptionsParser

  attr_reader :clazz

  def initialize(clazz, options = {})
    @clazz = clazz
    @options = options
  end

  def build
    definitions.each do |definition|
      definition.build(clazz)
    end
  end

  def add_method(name, code = nil, &block)
    definitions << MethodDefinition.new(name, code, &block)
  end

  def eval_and_add_method(name, &block)
    add_method(name, instance_eval(&block))
  end

  private

  def definitions
    @definitions ||= []
  end
end
