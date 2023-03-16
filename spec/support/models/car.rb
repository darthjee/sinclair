# frozen_string_literal: false

class Car < Sinclair::Model
  initialize_with(:brand, :model, writter: false)
end
