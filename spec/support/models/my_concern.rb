require_relative 'validator_builder'

module MyConcern
  extend ActiveSupport::Concern

  class_methods do
    def validate(*fields, expected_class)
      builder = ::ValidationBuilder.new(self, expected: expected_class)

      validatable_fields.concat(fields)
      builder.add_accessors(fields)

      fields.each do |field|
        builder.add_validation(field)
      end

      builder.build
    end

    def validatable_fields
      @validatable_fields ||= []
    end
  end

  def valid?
    self.class.validatable_fields.all? do |field|
      public_send("#{field}_valid?")
    end
  end
end
