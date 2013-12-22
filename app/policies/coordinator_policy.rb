# @author Alexander Clelland
class CoordinatorPolicy < ApplicationPolicy

  def index?
    @user.is_coordinator?
  end

  alias_method :start_new_year?, :index?
  alias_method :select_supervisors?, :index?
  alias_method :set_deadlines?, :index?

end
