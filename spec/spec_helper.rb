# frozen_string_literal: true

require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
end

SimpleCov.start 'gem'

require 'sinclair'
require 'sinclair/matchers'
require 'pry-nav'

support_files = File.expand_path('spec/support/**/*.rb')

Dir[support_files].sort.each { |file| require file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'
  config.include Sinclair::Matchers
end

RSpec::Matchers.define_negated_matcher :not_change, :change
