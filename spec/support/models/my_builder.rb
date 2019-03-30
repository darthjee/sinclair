# frozen_string_literal: true

class MyBuilder < Sinclair
  def add_methods
    if options_object.rescue_error
      add_method(:symbolize) do
        begin
          @variable.to_sym
        rescue StandardError
          :default
        end
      end
    else
      add_method(:symbolize) { @variable.to_sym }
    end
  end
end
