# Service object to handle querying for log events for a Taskable
#
# @author Brendan MacDonell
class EventsService
  SUBMISSION_TYPE = SubmissionEvent.name

  def initialize(taskable)
    @taskable = taskable
    @events = nil
  end

  # Return all events associated with the taskable, in chronological order
  def events
    if @events.nil?
      @events = @taskable.task.log_events.includes(:details).chronological
    end

    return @events
  end

  # Returns the latest submission event for the taskable
  def last_submission_event
    submission_events = events.where(details_type: SUBMISSION_TYPE)
    submission_events.first.try(:details)
  end

end
