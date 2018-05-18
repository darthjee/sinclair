class ConcernBuilder
  class OptionsParser::Dummy
    include OptionsParser

    def initialize(options)
      @options = options.deep_dup
    end

    def the_method
      return 'missing option' if options_object.switch.nil?

      if options_object.switch
        "The value is #{options_object.option_1}"
      else
        "The value is not #{options_object.option_1} but #{options_object.option_2}"
      end
    end
  end
end
