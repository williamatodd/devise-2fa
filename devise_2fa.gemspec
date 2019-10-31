$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "devise-2fa/version"

# Describe your gem and declare its dependencies:
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
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "rails", ">= 4.1", "< 6.1"

  gem.add_runtime_dependency 'devise', '~> 4.6'
  gem.add_runtime_dependency 'rotp', '~> 5.1'
  gem.add_runtime_dependency 'rqrcode', '~> 0.10.1'
  gem.add_runtime_dependency 'symmetric-encryption', '~> 4.3.0'

  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'rspec_junit_formatter'
  gem.add_development_dependency 'selenium-webdriver'
end
