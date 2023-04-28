class RubyStringCaster < Sinclair::Caster
  master_caster!

  cast_with(NilClass) { 'nil' }
  cast_with(Symbol) { |value| ":#{value}" }
  cast_with(Class, :to_s)
  cast_with(Hash, :to_s)
  cast_with(Array, :to_s)
  cast_with(Object, :to_json)

  def self.to_ruby_string(value)
    cast(value, value.class)
  end
end

