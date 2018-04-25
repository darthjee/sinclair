require 'active_support'
require 'active_support/all'

class ConcernBuilder
  require 'concern_builder/version'
  require 'concern_builder/options_parser'

  include OptionsParser

  attr_reader :methods_def

  def initialize(instance, options = {})
    @instance = instance
    @options = options
    @methods_def = []
  end

  def build
    methods_def.each do |method_def|
      @instance.module_eval(method_def, __FILE__, __LINE__ + 1)
    end
  end

  def add_method(name, code = nil, &block)
    if code.is_a?(String)
      add_code_method(name, code)
    else
      add_block_method(name, block)
    end
  end

  private

  def add_block_method(name, block)
    @instance.send(:define_method, name, block)
  end

  def add_code_method(name, code)
    @methods_def << <<-CODE
      def #{name}
        #{code}
      end
    CODE
  end
end
