# frozen_string_literal: true

class Human < Sinclair::Model.for(:name, :age, { gender: :undefined }, **{})
end
