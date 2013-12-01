# @author Alexander Clelland
class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all.includes(:supervisors)
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
      current_user.join_project(@project)

      # create programmes based on params
      # TODO: Validation to ensure programmes were created properly, not sure if this is how this should be done either

      params[:project][:programmes].each do |programme|
        Programme.create(programme: programme, project_id: @project.id)
      end
    end

    respond_with @project
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project

    @project.destroy
    respond_with @project
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
