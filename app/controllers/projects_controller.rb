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
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.save
    redirect_to @project
  end

  def destroy
    Project.find(params[:id]).destroy
    redirect_to action: :index
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
