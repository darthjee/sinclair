# frozen_string_literal: true

class Sinclair
  module EnvSettable
    class Builder < Sinclair
      def initialize(klass, prefix, *settings_name, **defaults)
        super(klass, prefix: prefix)

        @settings = Hash[settings_name.map { |name| [name] }]

        @settings.merge!(defaults)

        add_all_methods
      end

      private

      attr_reader :settings
      delegate :prefix, to: :options_object

      def add_all_methods
        settings.each do |name, value|
          key = [prefix, name].compact.join('_').to_s.upcase

          add_class_method(name) do
            ENV[key] || value
          end
        end
      end
    end
  end
end
