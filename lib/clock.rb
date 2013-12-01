require 'clockwork'
require './config/boot'
require './config/environment'


module Clockwork
  every 1.hour, 'tasks.send_deadline_expired_event', at: '**:00' do
    Task.delay.send_deadline_expired_events
  end
end
