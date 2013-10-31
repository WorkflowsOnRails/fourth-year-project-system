# TODO: Document this and extract some of the common code
#
# @author Brendan MacDonell
class FeedbackEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    # TODO: Check authorization
    @task = Task.find(params[:task_id])
    params = ActiveSupport::HashWithIndifferentAccess.new(
      user: current_user,
      task: @task,
    )
    params.merge!(feedback_event_params)
    feedback_event = FeedbackEvent.create(params)
    fire_event!(@task, feedback_event)
    # TODO: Validation
    redirect_to @task.taskable
  end

  private

  def fire_event!(task, feedback_event)
    if feedback_event.accepted
      task.taskable.accept!
    else
      task.taskable.return!
    end
  end

  def feedback_event_params
    params.require(:feedback_event).permit(
      :accepted,
      :comment,
      :submission_event_id,
    )
  end
end
