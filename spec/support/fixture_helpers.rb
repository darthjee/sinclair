require 'active_support'

module FixtureHelpers
  def load_fixture_file(filename)
      File.read (['./spec/', 'fixtures', filename].join('/'))
  end

  def load_json_fixture_file(filename)
    cached_json_fixture_file(filename)
  end

  private

  def cached_json_fixture_file(filename)
      ActiveSupport::JSON.decode(load_fixture_file(filename))
  end
end

RSpec.configuration.include FixtureHelpers
