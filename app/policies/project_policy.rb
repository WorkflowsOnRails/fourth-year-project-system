# @author Brendan MacDonell
class ProjectPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    @user.is_supervisor?
  end

  def update?
    @user.is_coordinator? || user_supervises_project
  end

  alias_method :destroy?, :update?

  private

  def user_supervises_project
    @user.is_supervisor? && @record.supervisors.include?(@user)
  end
end
