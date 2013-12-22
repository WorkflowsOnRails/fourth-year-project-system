require 'clockwork'
require './config/boot'
require './config/environment'

# Ensure all of the models are loaded so that automatic registration
#  works properly.
Rails.application.eager_load!

module Clockwork
  every 1.hour, 'Expirable.send_expired_events', at: '**:41' do
    Expirable.send_expired_events
  end
end
