# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Matchers module will have the DSL to be included in RSpec in order to have
  # access to the matchers
  #
  # @example
  #  RSpec.configure do |config|
  #    config.include Sinclair::Matchers
  #  end
  #
  #  class MyModel
  #  end
  #
  #  RSpec.describe 'my test' do
  #    let(:klass)   { Class.new(MyModel) }
  #    let(:builder) { Sinclair.new(klass) }
  #
  #    before do
  #      builder.add_method(:class_name, 'self.class.name')
  #    end
  #
  #    it do
  #      expect { builder.build }.to add_method(:class_name).to(klass)
  #    end
  #  end
  module Matchers
    autoload :Base,                   'sinclair/matchers/base'
    autoload :AddInstanceMethod,      'sinclair/matchers/add_instance_method'
    autoload :AddClassMethod,         'sinclair/matchers/add_class_method'
    autoload :AddMethodTo,            'sinclair/matchers/add_method_to'
    autoload :AddInstanceMethodTo,    'sinclair/matchers/add_instance_method_to'
    autoload :AddClassMethodTo,       'sinclair/matchers/add_class_method_to'
    autoload :ChangeClassMethodOn,    'sinclair/matchers/change_class_method_on'
    autoload :ChangeInstanceMethodOn, 'sinclair/matchers/change_instance_method_on'

    # DSL to AddInstanceMethod
    #
    # @example (see Sinclair::Matchers)
    # @example (see Sinclair::Matchers::AddInstanceMethod#to)
    #
    # @return [AddInstanceMethod] RSpec Matcher
    def add_method(method)
      Sinclair::Matchers::AddInstanceMethod.new(method)
    end

    # DSL to AddClassMethod
    #
    # @example (see Sinclair::Matchers)
    # @example (see Sinclair::Matchers::AddClassMethod#to)
    #
    # @return [AddClassMethod] RSpec Matcher
    def add_class_method(method)
      Sinclair::Matchers::AddClassMethod.new(method)
    end
  end
end
