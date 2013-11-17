# @author Alexander Clelland
class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.includes(:supervisors)
  end

  def show
    @project = Project.find(params[:id])
    authorize @project

    @programmes = Programme.where(project_id: params[:id])

  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
  
      #create programmes based on params
      # TODO: Validation to ensure programmes were created properly, not sure if this is how this should be done either
      params[:project][:programmes].each do |programme| 
        Programme.create(programme: programme, project_id: @project.id)
      end

      redirect_to @project
    else
      flash[:alert] = "Error(s) when creating project. See below for more information"
      render :new #render the form again and show errors
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project

    #remove programme references
    Programme.where(project_id: params[:id]).each do |programme|
      programme.destroy
    end

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
