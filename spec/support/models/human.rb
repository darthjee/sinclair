# frozen_string_literal: true

class Human < Sinclair::Model
  initialize_with :name, :age, { gender: :undefined }, **{}
end
