class Sinclair
  module Matchers
    autoload :AddMethod, 'sinclair/matchers/add_method'
  end
end

module RSpec
  module Matchers
    def add_method(method)
      Sinclair::Matchers::AddMethod.new(:index)
    end
  end
end
