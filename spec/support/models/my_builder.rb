class ValidationBuilder < ConcernBuilder
  delegate :expected, to: :options_object

  def initialize(clazz, options={})
    super
  end

  def add_validation(field)
    add_method("#{field}_valid?", "#{field}.is_a?#{expected}")
  end

  def add_accessors(fields)
    clazz.send(:attr_accessor, *fields)
  end
end
