class DefaultValue
  delegate :build, to: :builder
  attr_reader :klass, :method, :value

  def initialize(klass, method, value)
    @klass = klass
    @method = method
    @value = value
  end

  private

  def builder
    @builder ||= Sinclair.new(klass).tap do |b|
      b.add_method(method) { value }
    end
  end
end
