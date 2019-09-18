# frozen_string_literal: true

class DefaultValue
  delegate :build, to: :builder
  attr_reader :klass, :method, :value, :class_method

  def initialize(klass, method, value, class_method: false)
    @klass = klass
    @method = method
    @value = value
    @class_method = class_method
  end

  private

  def builder
    @builder ||= Sinclair.new(klass).tap do |b|
      if class_method
        b.add_class_method(method) { value }
      else
        b.add_method(method) { value }
      end
    end
  end
end
