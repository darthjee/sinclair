# frozen_string_literal: true

class DefaultValueBuilder < Sinclair
  def add_default_values(*methods)
    default_value = value

    methods.each do |method|
      add_method(method, cached: cache_type) { default_value }
    end

    build
  end

  private

  delegate :accept_nil, :value, to: :options_object

  def cache_type
    accept_nil ? :full : :simple
  end
end
