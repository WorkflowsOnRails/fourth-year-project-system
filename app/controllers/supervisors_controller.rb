# @author Alexander Clelland
class SupervisorsController < ApplicationController
  before_action :authenticate_user!

  # Problem:  policies are defined on objects, and we want to set
  #           a policy for managing supervisors, not for managing
  #           users (anyone can manage themselves.)
  # Solution: define a policy for the controller itself, and call
  #           `authorize self`.
  def self.policy_class
    SupervisorPolicy
  end

  def index
    authorize self
    @supervisors = User.where(role: User::SUPERVISOR_ROLE)
  end

  def new
    authorize self
    @supervisor = User.new
  end

  def create
    authorize self

    @supervisor = User.new(user_params)
    @supervisor.role = User::SUPERVISOR_ROLE

    if @supervisor.save
      flash[:notice] = "Supervisor created successfully"
      redirect_to action: :index #go back to the list of supervisors
    else
      flash[:alert] = "Error(s) when creating supervisor. See below for more information"
      render :new #render the form again and show errors
    end
  end

  def destroy
    authorize self

    supervisor = User.find(params[:id])

    #check every project that the user supervises, Cannot delete if only supervisor
    supervisor.projects.each do |project|
      if !(project.supervisors.length > 1)
        flash[:alert] = "Supervisor cannot be deleted if they are the last Supervisor of a project"
        return redirect_to action: :index
      end
    end

    #if program gets here there is either no project or supervisor is not last supervisor in any project
    supervisor.destroy
    flash[:notice] = "Supervisor deleted successfully"
    redirect_to action: :index
  end

  def user_params
    params.require(:user)
          .permit(:full_name, :email, :password, :password_confirmation)
  end

end
