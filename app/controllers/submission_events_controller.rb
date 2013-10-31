# TODO: Document this and extract some of the common code
#
# @author Brendan MacDonell
class SubmissionEventsController < ApplicationController
  before_action :authenticate_user!

  def create
    # TODO: Check authorization
    @task = Task.find(params[:task_id])
    params = ActiveSupport::HashWithIndifferentAccess.new(
      user: current_user,
      task: @task,
    )
    params.merge!(submission_event_params)
    SubmissionEvent.create(params)
    @task.taskable.submit!
    # TODO: Validation
    redirect_to @task.taskable
  end

  private

  def submission_event_params
    params.require(:submission_event).permit(:comment, :attachment)
  end
end
