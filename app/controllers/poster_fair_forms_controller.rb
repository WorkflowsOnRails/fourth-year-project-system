# @author Brendan MacDonell
class PosterFairFormsController < ApplicationController
  include AasmActionable::ControllerMixin

  before_action :authenticate_user!

  def show
    @taskable = find_taskable()
    authorize @taskable
  end

  def submit
    @taskable = find_taskable()
    authorize @taskable
    @taskable.assign_attributes(taskable_params)

    # Work around responders attempting to render an edit template ...
    if @taskable.submit!
      respond_with @taskable
    else
      flash[:error] = 'Your form has errors. Please fix them and resubmit.'
      render 'show'
    end
  end

  def retract
    @taskable = find_taskable()
    authorize @taskable
    @taskable.retract!
    # TODO: Figure out why this won't render a flash message ...
    respond_with @taskable
  end

  private

  def find_taskable
    PosterFairForm.find(params[:id])
  end

  def taskable_params
    params.require(:poster_fair_form).permit(:requests)
  end
end
