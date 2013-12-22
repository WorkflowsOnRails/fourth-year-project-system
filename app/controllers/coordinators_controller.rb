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

    User.where(role: User::GROUP_MEMBER_ROLE).each do |member|
      member.destroy
    end

    Project.delete_all
    Deadline.delete_all

    redirect_to action: :select_supervisors
  end

  def select_supervisors
    authorize self
    @supervisors = User.where(role: User::SUPERVISOR_ROLE)
  end

  def set_deadlines
    authorize self
    @deadlines = DeadlinesController::DEADLINES.map do |name, klass|
      [name, Deadline.find_or_initialize_by_task_type(klass)]
    end
  end

end
