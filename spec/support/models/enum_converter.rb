# frozen_string_literal: false

module EnumConverter
  class << self
    def to_hash(value)
      return value if value.is_a?(Hash)

      hash_caster.cast(value)
    end

    def to_array(value)
      return value if value.is_a?(Array)

      array_caster.cast(value)
    end

    private

    def hash_caster
      @hash_caster ||= EnumCaster.caster_for(:hash)
    end

    def array_caster
      @array_caster ||= EnumCaster.caster_for(:array)
    end
  end
end
