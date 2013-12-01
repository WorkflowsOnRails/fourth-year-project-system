# Policy for managing supervisors as a coordinator.
#
# @author Brendan MacDonell
class SupervisorPolicy < ApplicationPolicy
  def access?
    @user.is_coordinator?
  end

  alias_method :create?, :access?
  alias_method :destroy?, :access?
  alias_method :index?, :access?
end
