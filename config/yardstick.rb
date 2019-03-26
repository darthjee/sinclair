# frozen_string_literal: true

require 'yardstick/rake/measurement'
require 'yardstick/rake/verify'
require 'yaml'

options = YAML.load_file('config/yardstick.yml')

Yardstick::Rake::Measurement.new(:yardstick_measure, options) do |measurement|
  measurement.output = 'measurement/report.txt'
end

Yardstick::Rake::Verify.new(:verify_measurements, options)
