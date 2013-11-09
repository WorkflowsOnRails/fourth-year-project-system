# @author Alexander Clelland
class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.includes(:supervisors)
  end

  def show
    @project = Project.find(params[:id])
    authorize @project

    @supervisors = @project.supervisors
    @group_members = @project.group_members
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
      redirect_to @project
    else
      flash[:alert] = "Error(s) when creating project. See below for more information"
      render :new #render the form again and show errors
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project

    @project.destroy

    flash[:notice] = "Project deleted successfully"
    redirect_to action: :index
  end

  def join
    @project = Project.find(params[:project_id])
    authorize @project
    current_user.join_project(@project)
    redirect_to @project
  end

  def leave
    @project = Project.find(params[:project_id])
    authorize @project
    current_user.leave_project(@project)
    redirect_to @project
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
