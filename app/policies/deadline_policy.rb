# @author Alexander Clelland
class DeadlinePolicy < ApplicationPolicy
  def access?
    @user.is_coordinator?
  end

  alias_method :index?, :access?
  alias_method :schedule?, :access?
end
