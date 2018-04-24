require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
end

SimpleCov.start 'gem'

require 'concern_builder'

support_files = File.expand_path("spec/support/**/*.rb")
Dir[support_files].each { |file| require file  }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'

  config.before do
  end
end
