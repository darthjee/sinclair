# frozen_string_literal: true

require './spec/support/models/default_value_builder'

module DefaultValueable
  def default_reader(*methods, value:, accept_nil: false)
    DefaultValueBuilder.new(
      self, value: value, accept_nil: accept_nil
    ).add_default_values(*methods)
  end
end
