# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darhtjee
  #
  # Class responsible for defining how to and casting values
  #
  # First the class needs to be configured using {.cast_with} and later
  # a value can be cast by using {.cast} or {.caster_for}
  #
  # Inheritance grants the hability to have different casting for different
  # purposes / applications / gems
  class Caster
    autoload :ClassMethods, 'sinclair/caster/class_methods'
    extend Caster::ClassMethods

    def initialize(&block)
      @block = block.to_proc
      @with_options = block.parameters.size > 1
    end

    def cast(value, **opts)
      opts = {} unless with_options?

      block.call(value, **opts)
    end

    private

    attr_reader :block, :with_options
    alias with_options? with_options

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
