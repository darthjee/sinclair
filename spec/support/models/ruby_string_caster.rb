class RubyStringCaster < Sinclair::Caster
  master_caster!

  cast_with(NilClass) { 'nil' }
  cast_with(Symbol) { |value| ":#{value}" }
  cast_with(String, :to_json)
  cast_with(Object, :to_s)

  def self.to_ruby_string(value)
    cast(value, value.class)
  end
end

