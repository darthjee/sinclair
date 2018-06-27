class Sinclair
  module Matchers
    autoload :AddMethod, 'sinclair/matchers/add_method'

    def add_method(method)
      Sinclair::Matchers::AddMethod.new(method)
    end
  end
end
