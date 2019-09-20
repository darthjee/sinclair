# frozen_string_literal: true

class Sinclair
  module EnvSettable
    def settings_prefix(prefix)
      @settings_prefix = prefix
    end

    def has_settings(*settings_name, **defaults)
      Sinclair.new(self).tap do |builder|
        mapping = Hash[settings_name.map { |name| [name] }]

        mapping.merge!(defaults)

        mapping.each do |name, value|
          key = [@settings_prefix, name].compact.join('_').to_s.upcase

          builder.add_class_method(name, cached: true) do
            ENV[key] || value
          end
        end
      end.build
    end
  end
end
