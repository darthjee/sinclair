class Sinclair
  module Matchers
    autoload :AddMethod,   'sinclair/matchers/add_method'
    autoload :AddMethodTo, 'sinclair/matchers/add_method_to'

    def add_method(method)
      Sinclair::Matchers::AddMethod.new(method)
    end
  end
end
