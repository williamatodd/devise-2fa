# frozen_string_literal: true

appraise 'rails_4_2_sqlite3' do
  gem 'rails', '4.2.11.3'
  gem 'sqlite3', '~> 1.3.6'
end

appraise 'rails_5_2_sqlite3' do
  gem 'rails', '5.2.4.4'
  gem 'sqlite3', '~> 1.3.6'
end

if Gem::Requirement.new('>= 2.5.0').satisfied_by?(Gem::Version.new(RUBY_VERSION))
  appraise 'rails_6_0_sqlite3' do
    gem 'rails', '6.0.3.4'
    gem 'sqlite3', '~> 1.4'
  end
end

appraise 'rails_4_2_mongodb' do
  gem 'rails', '4.2.11.3'
  gem 'mongoid', '5.4'
end

appraise 'rails_5_2_mongodb' do
  gem 'rails', '5.2.4.4'
  gem 'mongoid', '6.4'
end

if Gem::Requirement.new('>= 2.5.0').satisfied_by?(Gem::Version.new(RUBY_VERSION))
  appraise 'rails_6_0_mongodb' do
    gem 'rails', '6.0.3.4'
    gem 'mongoid', '7.2'
  end
end
