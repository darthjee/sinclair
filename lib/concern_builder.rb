require 'active_support'
require 'active_support/all'

class ConcernBuilder
  autoload :VERSION,       'concern_builder/version'
  autoload :OptionsParser, 'concern_builder/options_parser'

  include OptionsParser

  attr_reader :methods_def

  def initialize(instance, options = {})
    @instance = instance
    @options = options
    @methods_def = []
  end

  def build
    methods_def.each do |definition|
      build_method(definition)
    end
  end

  def add_method(name, code = nil, &block)
    methods_def << { name: name, code: code, block: block }
  end

  private
  
  def build_method(definition)
    if definition[:code].is_a?(String)
      add_code_method(definition[:name], definition[:code])
    else
      add_block_method(definition[:name], definition[:block])
    end
  end

  def add_block_method(name, block)
    @instance.send(:define_method, name, block)
  end

  def add_code_method(name, code)
    full_code = <<-CODE
      def #{name}
        #{code}
      end
    CODE
    
    @instance.module_eval(full_code, __FILE__, __LINE__ + 1)
  end
end
