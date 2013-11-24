class UsersController < ApplicationController

  def index
    @project = Project.find(params[:project_id])

    #TODO: proper filtering somehow
    #@users = User.where.not(project_id: @project.id) #not sure why this doesn't work
    @users= User.all
  end

  def add
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])

    #TODO: authenticate here

    @user.join_project(@project)

    #TODO: redirect back to the users page
    redirect_to @project
  end

  def remove
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])

    #TODO: authenticate here

    @user.leave_project(@project)

    #TODO: redirect back to the users page
    redirect_to @project
  end


end
