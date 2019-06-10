# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinclair/version'

Gem::Specification.new do |gem|
  gem.name                  = 'sinclair'
  gem.version               = Sinclair::VERSION
  gem.authors               = ['DarthJee']
  gem.email                 = ['darthjee@gmail.com']
  gem.homepage              = 'https://github.com/darthjee/sinclair'
  gem.description           = 'Gem for easy concern creation'
  gem.summary               = gem.description
  gem.required_ruby_version = '>= 2.5.0'

  gem.files                 = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables           = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths         = ['lib']

  gem.add_runtime_dependency 'activesupport', '~> 5.2.0'

  gem.add_development_dependency 'bundler',       '~> 1.16.1'
  gem.add_development_dependency 'pry-nav',       '~> 0.2.4'
  gem.add_development_dependency 'rake',          '>= 12.3.1'
  gem.add_development_dependency 'rspec',         '>= 3.8'
  gem.add_development_dependency 'rubocop',       '0.58.1'
  gem.add_development_dependency 'rubocop-rspec', '1.30.0'
  gem.add_development_dependency 'rubycritic',    '>= 4.0.2'
  gem.add_development_dependency 'simplecov',     '~> 0.16.x'
  gem.add_development_dependency 'yard',          '>= 0.9.18'
  gem.add_development_dependency 'yardstick',     '>= 0.9.9'
end
