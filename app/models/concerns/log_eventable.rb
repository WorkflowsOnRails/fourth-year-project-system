# Mixin supporting multi-table inheritance of LogEvents.
#
# LogEventables should be created by calling `make(task, user, params)`.
#
# Models mixing in LogEventable should implement fire_events!(taskable)
# to send appropriate events to the associated task when the log event
# is made.
#
# @author Brendan MacDonell
module LogEventable
  extend ActiveSupport::Concern

  included do
    has_one :log_event, as: :details
  end

  module ClassMethods
    def make(user, task, options = {})
      transaction do
        details = create(options)
        return details unless details.valid?
        LogEvent.create(user: user, task: task, details: details)
        details.fire_events!(task)
        details
      end
    end
  end
end
