# frozen_string_literal: true

class Sinclair
  class Model
    # @api private
    # @author Darthjee
    #
    # Options for building model class
    class BuilderOptions < Sinclair::Options
      with_options writter: true, comparable: true
    end
  end
end
