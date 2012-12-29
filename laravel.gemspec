# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'laravel/version'

Gem::Specification.new do |gem|
  gem.name          = "laravel"
  gem.version       = Laravel::VERSION
  gem.authors       = ["Nikhil Gupta"]
  gem.email         = ["me@nikhgupta.com"]
  gem.description   = %q{Readily build new web applications using Laravel framework for PHP.}
  gem.summary       = %q{This gem helps in readily creating new web application based on the Laravel framework for PHP with as much customization as possible. Moreover, it allows configuring existing Laravel applications, and installing Laravel bundles for them.}
  gem.homepage      = "https://github.com/nikhgupta/laravel"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = ["laravel"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # add some dependecies for this gem
  gem.add_dependency 'thor'

  # add some dependencies for this gem when in the development environment
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'aruba'
end
