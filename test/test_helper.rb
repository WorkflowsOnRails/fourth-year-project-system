ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'capybara/dsl'
require 'capybara/rails'

SimpleCov.start do
  add_filter "/test/"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Policies", "app/policies"
  add_group "Services", "app/services"
end


class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end


module TestHelper
  ActiveRecord::Migration.check_pending!

  extend ActiveSupport::Concern
  include Capybara::DSL

  included do
    setup :setup_database
  end

  def setup_database
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def refresh_page
    visit current_url
  end

  module Users
    extend ActiveSupport::Concern

    included do
      setup :setup_users
    end

    def setup_users
      # Keep track of the attributes so that we have access to the password
      @student_attrs = attributes_for(:student)
      @student = User.create(@student_attrs)

      @coordinator_attrs = attributes_for(:coordinator)
      @coordinator = User.create(@coordinator_attrs)
    end

    def login_student
      login_with_attrs @student_attrs
    end

    def login_coordinator
      login_with_attrs @coordinator_attrs
    end

    def logout
      click_on 'logout'
    end

    private

    def login_with_attrs attrs
      visit '/'
      within 'form#new_user' do
        fill_in 'Email', with: attrs[:email]
        fill_in 'Password', with: attrs[:password]
        click_on 'Sign in'
      end
    end
  end
end
