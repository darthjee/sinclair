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
    master_caster!

    # @method self.master_caster!
    # @api public
    #
    # Changes the class to be the master caster
    #
    # The master caster never checks with its an
    #
    # @example
    #   class BaseCaster < Sinclair::Caster
    #     cast_with(:string, :to_s)
    #   end
    #
    #   class MyCaster < BaseCaster
    #   end
    #
    #   MyCaster.cast(10, :string) # returns '10'
    #
    #   MyCaster.master_caster!
    #
    #   MyCaster.cast(10, :string) # returns 10
    #
    # @see Caster::ClassMethods#master_caster!
    #
    # @return [TrueClass]

    # @method self.cast_with
    # @api public
    #
    # Register a caster under a key
    #
    # @overload cast_with(key, method_name)
    #   @param key [Symbol] key where the caster will be store.
    #   @param method_name [Symbol] method to be called on the
    #     value that is being converted
    #
    #   @example Casting from pre registered symbol caster
    #     class MyCaster < Sinclair::Caster
    #       cast_with(:json, :to_json)
    #     end
    #
    #     MyCaster.cast({ key: :value }, :json) # returns '{"key":"value"}'
    #
    # @overload cast_with(key, &block)
    #   @param key [Symbol] key where the caster will be store.
    #   @param block [Proc] block to be used when casting the value.
    #
    #   @example Casting from pre registered block caster
    #     MyCaster.cast_with(:complex) do |hash|
    #       real = hash[:real]
    #       imaginary = hash[:imaginary]
    #
    #       "#{real.to_f} + #{imaginary.to_f} i"
    #     end
    #
    #     value = { real: 10, imaginary: 5 }
    #
    #     MyCaster.cast(value, :complex) # returns '10.0 + 5.0 i'
    #
    # @overload cast_with(class_key, method_name)
    #   @param class_key [Class] class to be used as key.
    #     This will be used as parent class when the calling {Caster.cast}.
    #   @param method_name [Symbol] method to be called on the
    #     value that is being converted.
    #
    #   @example Casting from pre registered class
    #     class MyCaster < Sinclair::Caster
    #       cast_with(Numeric, :to_i)
    #     end
    #
    #     MyCaster.cast('10', Integer) # returns 10
    #
    # @overload cast_with(class_key, &block)
    #   @param class_key [Class] class to be used as key.
    #     This will be used as parent class when the calling {Caster.cast}.
    #   @param block [Proc] block to be used when casting the value.
    #
    #   @example Casting from pre registered block caster from a class
    #     # hash_model.rb
    #
    #     class HashModel
    #       def initialize(hash)
    #         hash.each do |attribute, value|
    #           method_name = "#{attribute}="
    #
    #           send(method_name, value) if respond_to?(method_name)
    #         end
    #       end
    #     end
    #
    #     # hash_person.rb
    #     class HashPerson < HashModel
    #       attr_accessor :name, :age
    #     end
    #
    #     # caster_config.rb
    #     Caster.cast_with(HashModel) do |value, klass:|
    #       klass.new(value)
    #     end
    #
    #     Caster.cast_with(String, &:to_json)
    #
    #     # main.rb
    #     values = [
    #       { klass: String, value: { name: 'john', age: 20, country: 'BR' } },
    #       { klass: HashPerson, value: { name: 'Mary', age: 22, country: 'IT' } }
    #     ]
    #
    #     values.map! do |config|
    #       value = config[:value]
    #       klass = config[:klass]
    #
    #       Caster.cast(value, klass, klass: klass)
    #     end
    #
    #     values[0] # returns '{"name":"john","age":20,"country":"BR"}'
    #     values[1] # returns HashPerson.new(name: 'Mary', age: 22)
    #
    # @see Caster::ClassMethods#cast_with
    # @see Caster.caster_for
    # @see Caster.cast
    #
    # @return [Caster] the registered caster

    # @method self.cast
    # @api public
    #
    # Cast a value using the registered caster
    #
    # @overload cast(value, key, **opts)
    #   @param value [Object] value to be cast
    #   @param key [Symbol] key where the caster is registered under
    #   @param opts [Hash] Options to be sent to the caster
    #
    #   @example Casts with a symbol key
    #     # math_caster.rb
    #     class MathCaster < Sinclair::Caster
    #       cast_with(:float, :to_f)
    #
    #       cast_with(:log) do |value, base: 10|
    #         value = MathCaster.cast(value, :float)
    #
    #         Math.log(value, base)
    #       end
    #
    #       cast_with(:exp) do |value, base: 10|
    #         value = MathCaster.cast(value, :float)
    #
    #         base**value
    #       end
    #     end
    #
    #     # main.rb
    #     initial = Random.rand(10..20)
    #     log = MathCaster.cast(initial, :log)
    #     exp = MathCaster.cast(log, :exp)
    #
    #     # exp will be betwween initial - 0.0001 and initial + 0.0001
    #
    #   @example Casts passing parameter
    #     base = Random.rand(3..6)
    #     initial = Random.rand(10..20)
    #     log = MathCaster.cast(initial, :log, base: base)
    #     exp = MathCaster.cast(log, :exp, base: base)
    #
    #     # exp will be betwween initial - 0.0001 and initial + 0.0001
    #
    # @overload cast(value, class_key, **opts)
    #   @param value [Object] value to be cast
    #   @param class_key [Class] Class to used as key in the casters storage
    #   @param opts [Hash] Options to be sent to the caster
    #
    #   When the +class_key+ does not match the stored key, but matches a superclass,
    #   the registerd caster is returned.
    #
    #   @example Casts with class key
    #     # ruby_string_caster.rb
    #     class RubyStringCaster < Sinclair::Caster
    #       master_caster!
    #
    #       cast_with(NilClass) { 'nil' }
    #       cast_with(Symbol) { |value| ":#{value}" }
    #       cast_with(String, :to_json)
    #       cast_with(Object, :to_s)
    #
    #       def self.to_ruby_string(value)
    #         cast(value, value.class)
    #       end
    #     end
    #
    #     # main.rb
    #     hash = { a: 1, b: 2, 'c' => nil }
    #     string = 'my string'
    #     symbol = :the_symbol
    #     number = 10
    #     null = nil
    #
    #     <<-RUBY
    #       hash_value = #{RubyStringCaster.to_ruby_string(hash)}
    #       string_value = #{RubyStringCaster.to_ruby_string(string)}
    #       symbol_value = #{RubyStringCaster.to_ruby_string(symbol)}
    #       number = #{RubyStringCaster.to_ruby_string(number)}
    #       null_value = #{RubyStringCaster.to_ruby_string(null)}
    #     RUBY
    #
    #     # Generates the String
    #     #
    #     # <<-RUBY
    #     #   hash_value = {:a=>1, :b=>2, "c"=>nil}
    #     #   string_value = "my string"
    #     #   symbol_value = :the_symbol
    #     #   number = 10
    #     #   null_value = nil
    #     # RUBY
    #
    # @see Caster::ClassMethods#cast
    # @see Caster.cast_with
    # @see Caster.caster_for
    # @see Caster#cast
    #
    # @return [Object] the value cast

    # @method self.caster_for
    # @api public
    #
    # Returns an instance of caster for the provided key
    #
    # When no registered caster is found one is requested for the parent class.
    # If no caster is found, then a default caster is returned
    #
    # The default caster performs no casting returning the value itself
    #
    # @overload caster_for(key)
    #   @param key [Symbol] key where the caster is registered under
    #
    #   @example Getting the caster with symbol key
    #     # enum_caster.rb
    #     class EnumCaster < Sinclair::Caster
    #       cast_with(:hash, :to_h)
    #       cast_with(:array, :to_a)
    #     end
    #
    #     # enum_converter.rb
    #     module EnumConverter
    #       class << self
    #         def to_hash(value)
    #           return value if value.is_a?(Hash)
    #
    #           hash_caster.cast(value)
    #         end
    #
    #         def to_array(value)
    #           return value if value.is_a?(Array)
    #
    #           array_caster.cast(value)
    #         end
    #
    #         private
    #
    #         def hash_caster
    #           @hash_caster ||= EnumCaster.caster_for(:hash)
    #         end
    #
    #         def array_caster
    #           @array_caster ||= EnumCaster.caster_for(:array)
    #         end
    #       end
    #     end
    #
    #     # main.rb
    #     EnumConverter.to_array({ key: :value }) # returns [%i[key value]]
    #     EnumConverter.to_hash([%i[key value]]) # returns { key: :value }
    #
    # @overload caster_for(class_key)
    #   @param class_key [Class] Class to used as key in the casters storage
    #
    #   When the +class_key+ does not match the stored key, but matches a superclass,
    #   the registerd caster is returned.
    #
    #   @example Getting the caster with class key'
    #     # stringer_parser.rb
    #     class StringParser < Sinclair::Caster
    #       master_caster!
    #
    #       cast_with(JSON) { |value| JSON.parse(value) }
    #       cast_with(Integer, :to_i)
    #       cast_with(Float, :to_f)
    #     end
    #
    #     # main.rb
    #     StringParser.cast('{"key":"value"}', JSON) # returns { "key" => "value" }
    #     StringParser.cast('10.2', Integer) # returns 10
    #     StringParser.cast('10.2', Float) # returns 10.2
    #
    # @see Caster::ClassMethods#caster_for
    # @see Caster.cast_with
    # @see Caster.cast
    #
    # @return [Caster]

    # @param block [Proc] Proc to be used when converting the value object
    def initialize(&block)
      @block = block&.to_proc
    end

    # Cast a value using the given the set +block+
    #
    # @param value [Object] value to be converted
    # @param opts [Hash] options to be sent to the block
    #
    # When the block does not accept options, those
    # are not passed
    #
    # @example Casts from a selected caster
    #   # math_caster.rb
    #   class MathCaster < Sinclair::Caster
    #     cast_with(:float, :to_f)
    #
    #     cast_with(:log) do |value, base: 10|
    #       value = MathCaster.cast(value, :float)
    #
    #       Math.log(value, base)
    #     end
    #   end
    #
    #   # main.rb
    #   caster = MathCaster.caster_for(:log)
    #
    #   caster.cast(100) # returns 2
    #   caster.cast(8, base: 2) # returns 3
    #
    # @return [Object] the result of the converting block
    def cast(value, **opts)
      return value unless block

      options = opts.select do |key, _|
        options_keys.include?(key)
      end

      block.call(value, **options)
    end

    private

    # @api private
    # @private
    #
    # Keys of options accepted by the block
    #
    # @return [Array<Symbol>]
    def options_keys
      @options_keys ||= block.parameters.select do |(type, _)|
        %i[key keyreq].include? type
      end.map(&:second)
    end

    # @method block
    # @api private
    # @private
    #
    # Proc to be used when converting the value object
    #
    # @return [Proc]
    attr_reader :block
  end
end
