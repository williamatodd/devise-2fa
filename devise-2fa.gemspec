# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise-2fa/version'

Gem::Specification.new do |gem|
  gem.name          = 'devise-2fa'
  gem.version       = Devise::TwoFactor::VERSION
  gem.authors       = ['William A. Todd']
  gem.email         = ['info@rockcreek.io']
  gem.description   = 'Time Based OTP/rfc6238 authentication for Devise'
  gem.summary       = 'Includes ActiveRecord and Mongoid ORM support'
  gem.homepage      = 'http://www.github.com/williamatodd/devise-2fa'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'devise'
  gem.add_runtime_dependency 'rotp', '~> 3.0'
  gem.add_runtime_dependency 'rqrcode', '~> 0.10.1'
  gem.add_runtime_dependency 'symmetric-encryption', '~> 4.0'

  gem.add_development_dependency 'sqlite3', '~> 0'
  gem.add_development_dependency 'rspec'
end
