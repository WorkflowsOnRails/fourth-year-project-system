class OralPresentationFormsController < ApplicationController
  include StateActionRenderable

  before_action :authenticate_user!

  def show
    @taskable = find_taskable()
    authorize @taskable
  end

  def submit
    @taskable = find_taskable()
    authorize @taskable
    @taskable.available_times = params[:submit_available_times]
    @taskable.submit
    @taskable.accept_for_user(current_user)
    @taskable.save!
    respond_with @taskable
  end

  def accept
    @taskable = find_taskable()
    @taskable.accept_for_user(current_user)
    @taskable.save!
    respond_with @taskable
  end

  private

  def find_taskable
    OralPresentationForm.find(params[:id])
  end
end
