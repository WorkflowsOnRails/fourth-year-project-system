ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'capybara/dsl'
require 'capybara/rails'

SimpleCov.start


class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end


module TestHelper
  ActiveRecord::Migration.check_pending!

  include Capybara::DSL

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
