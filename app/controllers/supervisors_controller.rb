class SupervisorsController < ApplicationController

  def new
    if current_user.is_coordinator?
      @supervisor = User.new
    end
  end

  def create
    if current_user.is_coordinator?
      @user = User.create(user_params)
      @user.role = User::SUPERVISOR_ROLE
      @user.save
    end

    #TODO: Not sure how to set up some type of flash message to notify created
    redirect_to action: :new
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

end
