source 'https://rubygems.org'

gemspec

gem 'rdoc'

group :test do
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.beta1'
  end

  platforms :ruby do
    gem 'sqlite3', '~> 1.3.4'
  end

  gem 'devise', '~> 4.0'
  gem 'activerecord', '~> 4.2.6'
  gem 'mongo'

  gem 'rspec'

  gem 'capybara'
  gem 'shoulda'
  gem 'selenium-webdriver'

  gem 'minitest-reporters', '>= 0.5.0'
end
