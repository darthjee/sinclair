# frozen_string_literal: true

class MyBuilder < Sinclair
  def add_methods
    if options_object.rescue_error
      add_safe_method
    else
      add_method(:symbolize) { @variable.to_sym }
    end
  end

  def add_safe_method
    add_method(:symbolize) do
      begin
        @variable.to_sym
      rescue StandardError
        :default
      end
    end
  end
end
