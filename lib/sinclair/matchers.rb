# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Matchers module will have the DSL to be included in RSpec in order to have
  # access to the matchers
  #
  # @example (see Sinclair::Matchers::AddClassMethod)
  # @example (see Sinclair::Matchers::AddInstanceMethod)
  # @example (see Sinclair::Matchers::ChangeClassMethod)
  # @example (see Sinclair::Matchers::ChangeInstanceMethod)
  module Matchers
    autoload :Base,                   'sinclair/matchers/base'
    autoload :AddInstanceMethod,      'sinclair/matchers/add_instance_method'
    autoload :AddClassMethod,         'sinclair/matchers/add_class_method'
    autoload :AddMethod,              'sinclair/matchers/add_method'
    autoload :AddMethodTo,            'sinclair/matchers/add_method_to'
    autoload :AddInstanceMethodTo,    'sinclair/matchers/add_instance_method_to'
    autoload :AddClassMethodTo,       'sinclair/matchers/add_class_method_to'
    autoload :ChangeClassMethod,      'sinclair/matchers/change_class_method'
    autoload :ChangeInstanceMethod,   'sinclair/matchers/change_instance_method'
    autoload :ChangeMethodOn,         'sinclair/matchers/change_method_on'
    autoload :ChangeClassMethodOn,    'sinclair/matchers/change_class_method_on'
    autoload :ChangeInstanceMethodOn, 'sinclair/matchers/change_instance_method_on'
    autoload :MethodTo,               'sinclair/matchers/method_to'

    # DSL to AddInstanceMethod
    #
    # @example (see Sinclair::Matchers::AddInstanceMethod#to)
    #
    # @return [AddInstanceMethod] RSpec Matcher
    def add_method(method_name)
      Sinclair::Matchers::AddInstanceMethod.new(method_name)
    end

    # DSL to AddClassMethod
    #
    # @example (see Sinclair::Matchers::AddClassMethod#to)
    #
    # @return [AddClassMethod] RSpec Matcher
    def add_class_method(method_name)
      Sinclair::Matchers::AddClassMethod.new(method_name)
    end

    # DSL to ChangeInstanceMethod
    #
    # @example (see Sinclair::Matchers::ChangeInstanceMethod#to)
    #
    # @return [ChangeInstanceMethod] RSpec Matcher
    def change_method(method_name)
      Sinclair::Matchers::ChangeInstanceMethod.new(method_name)
    end

    # DSL to ChangeClassMethod
    #
    # @example (see Sinclair::Matchers::ChangeClassMethod#to)
    #
    # @return [ChangeClassMethod] RSpec Matcher
    def change_class_method(method_name)
      Sinclair::Matchers::ChangeClassMethod.new(method_name)
    end
  end
end
