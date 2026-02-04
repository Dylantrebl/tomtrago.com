source 'https://rubygems.org'
ruby '~> 3.4.7'

gem 'autoprefixer-rails', '>= 10.0'
# Use fog-aws for S3 (CarrierWave); full aws-sdk pulls in 200+ gems and exceeds Heroku slug limit (500MB)
gem 'carrierwave', '~> 1.2', '>= 1.2.2'
gem 'carrierwave-base64', '~> 2.6', '>= 2.6.1'
gem 'fog-aws', '~> 2.0', '>= 2.0.1'
gem 'js-routes', '~> 1.3'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '7.2.2'
gem 'sassc-rails'
gem 'simple_form', '>= 5.1'
gem 'terser'

group :development, :test do
  gem 'rubocop', '~> 0.53.0'
end

group :development do
  gem 'dotenv-rails'
  gem 'listen', '>= 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 4.0.0'
end
