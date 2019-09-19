# frozen_string_literal: true

class Sinclair
  module EnvSettable
    def has_settings(*settings_name)
      Sinclair.new(self).tap do |builder|
        settings_name.each do |name|
          key = name.to_s.upcase

          builder.add_class_method(name, cached: true) do
            ENV[key]
          end
        end
      end.build
    end
  end
end
