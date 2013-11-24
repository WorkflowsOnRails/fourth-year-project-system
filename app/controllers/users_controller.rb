class UsersController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    authorize @project, :users?

    #TODO: more filtering... this is very stupid and hacky... need to figure out how to do raw SQL calls
    #      need to add in filtering based off programme, sort by full_name,

    @supervisors = []
    temp = User.all
    temp.each do |user|
      if user.is_supervisor? && !user_supervises_project?(user, @project)
        @supervisors << user
      end
    end

    @group_members = []
    temp = User.all
    temp.each do |user|
      if user.is_group_member? && !group_member_in_project?(user, @project)
        @group_members << user
      end
    end

  end

  def add
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    authorize @project

    # is the user in the project?
    if !(user_supervises_project?(@user, @project) || group_member_in_project?(@user, @project))
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
    if user_supervises_project?(@user, @project) || group_member_in_project?(@user, @project)
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

  private 

  def user_supervises_project?(user, project)
    user.is_supervisor? && project.supervisors.include?(user)
  end

  def group_member_in_project?(user, project)
    user.is_group_member? && project.group_members.include?(user)
  end

end
