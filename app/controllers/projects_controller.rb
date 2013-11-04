# @author Alexander Clelland
class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    if !(current_user.is_coordinator? || current_user.is_supervisor?)
      render status: :forbidden, :text => "You are not allowed to create a project"
      return 
    end

    @project = Project.new
  end

  def create
    if !(current_user.is_coordinator? || current_user.is_supervisor?)
      render status: :forbidden, :text => "You are not allowed to create a project"
      return 
    end

    @project = Project.new(project_params)
    if @project.save
      redirect_to @project
    else
      flash[:alert] = "Error(s) when creating project. See below for more information"
      render :new #render the form again and show errors
    end
  end

  def destroy
    if !(current_user.is_coordinator? || current_user.is_supervisor?)
      render status: :forbidden, :text => "You are not allowed to delete a project"
      return 
    end

    Project.find(params[:id]).destroy

    flash[:notice] = "Project deleted successfully"
    redirect_to action: :index
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
