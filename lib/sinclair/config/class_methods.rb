# frozen_string_literal: true

class Sinclair
  class Config
    module ClassMethods
      def add_attributes(*attributes)
        new_attributes = attributes.map(&:to_sym) - self.attributes
        config_attributes.concat(new_attributes)
      end

      def attributes
        if superclass.is_a?(Config::ClassMethods)
          (superclass.attributes + config_attributes).uniq
        else
          config_attributes
        end
      end

      def add_configs(*args)
        Config::MethodsBuilder.new(self, *args).tap do |builder|
          builder.build

          add_attributes(*builder.config_names)
        end
      end

      private

      def config_attributes
        @config_attributes ||= []
      end
    end
  end
end
