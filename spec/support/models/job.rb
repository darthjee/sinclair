# frozen_string_literal: false

class Job < Sinclair::Model
  initialize_with({ state: :starting }, writter: true)
end
