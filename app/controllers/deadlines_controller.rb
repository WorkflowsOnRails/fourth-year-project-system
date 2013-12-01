class DeadlinesController < ApplicationController

  def index
    @deadlines = []

    @deadlines << Deadline.find_or_initialize_by_task_type(Proposal)
    @deadlines << Deadline.find_or_initialize_by_task_type(ProgressReport)
    @deadlines << Deadline.find_or_initialize_by_task_type(OralPresentationForm)
    @deadlines << Deadline.find_or_initialize_by_task_type(PosterFairForm)
    @deadlines << Deadline.find_or_initialize_by_task_type(FinalReport)
  end

  def schedule
    @deadline = Deadline.find_or_initialize_by_task_type(Object.const_get(params[:deadline_id]))
    authorize @deadline
  end

  def create
    set_deadline
    redirect_to action: :index
  end

  def update
    set_deadline
    redirect_to action: :index
  end

  def deadline_params
    params.require(:deadline).permit(:timestamp)
  end

private

  def set_deadline
    #TODO: Cannot create deadline in past, need validation in model maybe?
    if Deadline.find_or_initialize_by_task_type(Object.const_get(params[:deadline][:code])).update_attributes(deadline_params)
      flash[:notice] = "Deadline scheduled successfully"
    else
      flash[:alert] = "Deadline cannot be scheduled in the past"
    end
  end

end
