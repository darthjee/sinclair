# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'concern_builder/version'

Gem::Specification.new do |gem|
  gem.name          = 'concern_builder'
  gem.version       = ConcernBuilder::VERSION
  gem.authors       = ["DarthJee"]
  gem.email         = ["darthjee@gmail.com"]
  gem.homepage      = 'https://github.com/darthjee/concern_builder'
  gem.description   = 'Gem for easy concern creation'
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport', '~> 5.1.4'

  gem.add_development_dependency "bundler", "~> 1.6"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency 'simplecov'
end

