# @author Brendan MacDonell
class OralPresentationsController < ApplicationController
  include AasmActionable::ControllerMixin

  before_action :authenticate_user!

  def show
    @taskable = find_taskable()
    authorize @taskable
  end

  def update
    @taskable = find_taskable()
    authorize @taskable
    respond_with @taskable
  end

  private

  def find_taskable
    OralPresentation.find(params[:id])
  end
end
