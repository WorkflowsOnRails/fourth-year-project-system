# Central controller responsible for displaying tasks to the user. There
# are no mutation actions here - such actions should be performed by
# controllers for taskable implementations, or by the central workflow
# itself.
#
# @author Brendan MacDonell
class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @pending_tasks = current_user.tasks.pending
    @completed_tasks = current_user.tasks.completed
  end

  def show
    # TODO: Authorization
    @task = Task.find(params[:id])
    redirect_to @task.taskable
  end
end
