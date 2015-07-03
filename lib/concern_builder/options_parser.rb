module ConcernBuilder::OptionsParser
  extend ActiveSupport::Concern

  attr_reader :options

  def options_object
    @options_object ||= OpenStruct.new options
  end
end
