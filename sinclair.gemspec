# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinclair/version'

Gem::Specification.new do |gem|
  gem.name          = 'sinclair'
  gem.version       = Sinclair::VERSION
  gem.authors       = ["DarthJee"]
  gem.email         = ["darthjee@gmail.com"]
  gem.homepage      = 'https://github.com/darthjee/sinclair'
  gem.description   = 'Gem for easy concern creation'
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport', '~> 5.2.0'

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'rake', '~> 12.0.0'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'simplecov', '~> 0.16.1'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'pry-nav'
end

