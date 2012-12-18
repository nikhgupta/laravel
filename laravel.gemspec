# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'laravel/version'

Gem::Specification.new do |gem|
  gem.name          = "laravel"
  gem.version       = Laravel::VERSION
  gem.authors       = ["Nikhil Gupta"]
  gem.email         = ["me@nikhgupta.com"]
  gem.description   = %q{A wrapper around Laravel framework for PHP}
  gem.summary       = %q{This gem is a wrapper around the Laravel framework for PHP. Initially, the gem would allow to create new laravel apps along with options to modify the default behavior for these new installations.}
  gem.homepage      = "https://github.com/nikhgupta/laravel"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  # gem.add_development_dependency 'guard-rspec'
  # gem.add_development_dependency 'rb-fsevent'
  # gem.add_development_dependency 'growl'
end
