# @author Brendan MacDonell
class OralPresentationsController < ApplicationController
  include AasmActionable::ControllerMixin

  before_action :authenticate_user!

  def show
    @taskable = find_taskable()
    authorize @taskable
  end

  def update_schedule
    @taskable = find_taskable()
    authorize @taskable

    if @taskable.update(oral_presentation_params)
      respond_with @taskable
    else
      render 'show'
    end
  end

  private

  def find_taskable
    OralPresentation.find(params[:id])
  end

  def oral_presentation_params
    params
      .require(:oral_presentation)
      .permit(:venue, :start, :finish)
  end
end
