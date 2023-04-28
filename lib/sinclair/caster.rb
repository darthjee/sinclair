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
      @options_keys = block.parameters.select { |l| %i[key keyreq].include? l.first }.map(&:second)
    end

    def cast(value, **opts)
      options = opts.select do |k, _|
        options_keys.include?(k)
      end

      block.call(value, **options)
    end

    private

    attr_reader :block, :options_keys

    cast_with(:string, :to_s)
    cast_with(:integer, :to_i)
    cast_with(:float, :to_f)
  end
end
