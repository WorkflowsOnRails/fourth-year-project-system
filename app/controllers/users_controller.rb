class UsersController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    authorize @project, :users?

    #TODO: more filtering... this is very stupid and hacky... need to figure out how to do raw SQL calls
    #      need to add in filtering based off programme, sort by full_name,

    @supervisors = []
    temp = User.all
    temp.each do |user|
      if user.is_supervisor? && !@project.has_supervisor?(user)
        @supervisors << user
      end
    end

    @group_members = []
    temp = User.all
    temp.each do |user|
      if user.is_group_member? && !@project.has_group_member?(user)
        @group_members << user
      end
    end

  end

  def add
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    authorize @project

    # is the user in the project?
    if !(@project.has_participant?(@user))
      @user.join_project(@project)
      flash[:notice] = "User successfully added to project."
    else 
      flash[:alert] = "User already exists in project."
    end

    #return to the list of users to add another user
    redirect_to project_users_path
  end

  def remove
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    authorize @project

    # is the user in the project?
    if @project.has_participant?(@user)
      #is the user the last supervisor?
      if !(@user.is_supervisor? && @project.supervisors.length <= 1)
        @user.leave_project(@project)
        return redirect_to @project, notice: "User successfully removed from project."
      else
        flash[:alert] = "You cannot remove the last Supervisor of a project"
      end
    else
      flash[:alert] = "User does not exist in this project"
    end

    return redirect_to @project
  end

end
