# frozen_string_literal: true

class Sinclair
  module EnvSettable
    def settings_prefix(prefix)
      @settings_prefix = prefix
    end

    def has_settings(*settings_name)
      Sinclair.new(self).tap do |builder|
        settings_name.each do |name|
          key = [@settings_prefix, name].compact.join('_').to_s.upcase

          builder.add_class_method(name, cached: true) do
            ENV[key]
          end
        end
      end.build
    end
  end
end
