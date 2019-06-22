# frozen_string_literal: true

class Sinclair
  class Config
    module ClassMethods
      def add_attributes(*attributes)
        new_attributes = attributes.map(&:to_sym) - self.attributes
        self.attributes.concat(new_attributes)
      end

      def attributes
        @attributes ||= []
      end
    end
  end
end
