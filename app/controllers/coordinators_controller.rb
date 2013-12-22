class CoordinatorsController < ApplicationController
  before_action :authenticate_user!

  def self.policy_class
    CoordinatorPolicy
  end

  def index
    authorize self
  end

  def start_new_year
    authorize self

    #TODO: delete all projects and group members here

    redirect_to action: :select_supervisors
  end

  def select_supervisors
    authorize self
  

  end

end
