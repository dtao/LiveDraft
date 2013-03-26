source "https://rubygems.org"

# Server requirements
gem "thin"

# Project requirements
gem "foreman"
gem "rake"
gem "sinatra-flash", :require => "sinatra/flash"

# Component requirements
gem "randy"
gem "coffee-script"
gem "sass"
gem "haml"
gem "json"
gem "glorify"
gem "nokogiri"
gem "dm-validations"
gem "dm-timestamps"
gem "dm-migrations"
gem "dm-constraints"
gem "dm-aggregates"
gem "dm-transactions"
gem "dm-core"
gem "dm-noisy-failures"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "pusher"

# Required for asynchronous Pusher updates
gem "em-http-request"

# Padrino Stable Gem
gem "padrino", "0.10.7"

group :development do
  gem "dm-sqlite-adapter"
  gem "pry"
end

group :production do
  gem "dm-postgres-adapter"
  gem "pg"
end
