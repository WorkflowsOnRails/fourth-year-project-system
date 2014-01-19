source 'https://rubygems.org'

gem 'rails', '4.0.0'

gem 'sqlite3', group: :development
gem 'pg', group: :production

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'jbuilder', '~> 1.2'

gem 'aasm', '~> 3.0.0'
gem 'clockwork'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'devise', '~> 3.1.1'
gem 'pundit'
gem 'anjlab-bootstrap-rails', '>= 3.0.0.0', :require => 'bootstrap-rails'
gem 'responders'
gem 'simple_form', '~> 3.0.0rc'
gem 'paperclip', '~> 3.0'
gem 'will_paginate', '~> 3.0.0'
gem 'stonepath', git: 'https://github.com/WorkflowsOnRails/stonepath.git', branch: 'rails-4'

gem 'aasm_actionable', git: 'https://github.com/WorkflowsOnRails/aasm_actionable.git', branch: 'master'
gem 'aasm_progressable', git: 'https://github.com/WorkflowsOnRails/aasm_progressable.git', branch: 'master'
gem 'expirable', git: 'https://github.com/WorkflowsOnRails/expirable.git', branch: 'master'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'puma'
gem 'foreman'

group :development do
  gem 'aasm_statecharts',
      git: 'https://github.com/WorkflowsOnRails/aasm_statecharts.git',
      branch: 'master'
end

group :development, :test do
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-debugger'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'annotate', '>=2.5.0', group: :development

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'random_data'
  gem 'simplecov'
  gem 'timecop'
end
