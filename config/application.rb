require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module FourthYearProjectSystem
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app/services)
    config.i18n.enforce_available_locales = true

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :test_unit, fixture: false
      g.assets          false
      g.javascripts     false
      g.stylesheets     false
      g.helper          false
    end
  end
end
