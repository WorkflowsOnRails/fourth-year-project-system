class SupervisorsController < ApplicationController
  before_action :authenticate_user!

  def index
    if !current_user.is_coordinator?
      render status: :forbidden, :text => "You are not a coordinator!"
      return
    end

    @supervisors = User.find(:all, :conditions => {:role => [User::SUPERVISOR_ROLE]})
  end

  def new
    if !current_user.is_coordinator?
      render status: :forbidden, :text => "You are not a coordinator!"
      return
    end

    @supervisor = User.new
  end

  def create
    if !current_user.is_coordinator?
      render status: :forbidden, :text => "You are not a coordinator!"
      return 
    end

    @supervisor = User.create(user_params)
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
    if !current_user.is_coordinator?
      render status: :forbidden, :text => "You are not a coordinator!"
      return 
    end

    User.find(params[:id]).destroy

    flash[:notice] = "Supervisor deleted successfully"
    redirect_to action: :index
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

end
