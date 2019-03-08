$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "devise_2fa/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name          = 'devise-2fa'
  gem.version       = Devise2fa::VERSION
  gem.authors       = ['William A. Todd']
  gem.email         = ['info@investinwaffles.com']
  gem.description   = 'Time Based OTP/rfc6238 authentication for Devise'
  gem.summary       = 'Includes ActiveRecord and Mongoid ORM support'
  gem.homepage      = 'http://www.github.com/williamatodd/devise-2fa'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # TODO Widen range of rails
  gem.add_dependency "rails", "~> 5.2.2"

  gem.add_runtime_dependency 'devise', '~> 4.0'
  gem.add_runtime_dependency 'rotp', '~> 3.0'
  gem.add_runtime_dependency 'rqrcode', '~> 0.10.1'
  gem.add_runtime_dependency 'symmetric-encryption', '~> 4.2.0'

  gem.add_development_dependency 'sqlite3', '~> 1.3.6'
end
