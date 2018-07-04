class ValidationBuilder < Sinclair
  delegate :expected, to: :options_object

  def initialize(klass, options={})
    super
  end

  def add_validation(field)
    add_method("#{field}_valid?", "#{field}.is_a?#{expected}")
  end

  def add_accessors(fields)
    klass.send(:attr_accessor, *fields)
  end
end
