module InitialValuer
  extend ActiveSupport::Concern

  class_methods do
    def initial_value_for(attribute, value)
      builder = Sinclair.new(self, initial_value: value)
      builder.eval_and_add_method(attribute) do
        "@#{attribute} ||= #{options_object.initial_value}"
      end
      builder.build
    end
  end
end
