class DeadlinesController < ApplicationController

  DEADLINES = [
      ['Proposal', Proposal],
      ['Progress Report', ProgressReport],
      ['Oral Presentation Scheduling Form', OralPresentationForm],
      ['Poster Fair Demo Form', PosterFairForm],
      ['Final Report', FinalReport],
    ]

  def index
    @deadlines = DEADLINES.map do |name, klass|
      [name, Deadline.find_or_initialize_by_task_type(klass)]
    end
    render 'index'
  end

  def update
    deadline = Deadline.find_or_initialize_by_task_type(deadline_class)
    saved = deadline.update_attributes(deadline_params)

    if saved
      flash[:notice] = "Deadline updated successfully"
      redirect_to deadlines_path
     else
      flash[:error] = <<-eos.html_safe
        <strong>There was a problem with the deadline:</strong>
        #{deadline.errors.full_messages.join('\n').downcase}
      eos
      index
    end
  end

  alias_method :create, :update

  private

  def deadline_params
    params.require(:deadline).permit(:timestamp)
  end

  def deadline_class
    Object.const_get(params[:deadline][:code])
  end

end
