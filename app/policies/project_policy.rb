# @author Brendan MacDonell
class ProjectPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    @user.is_supervisor?
  end

  def update?
    @user.is_coordinator? || user_supervises_project?
  end

  alias_method :destroy?, :update?

  def users?
    user_supervises_project?
  end

  def add?
    user_supervises_project?
  end

  def remove?
    user_supervises_project?
  end

  private

  def user_supervises_project?
    @user.is_supervisor? && @record.supervisors.include?(@user)
  end

  def group_member_in_project?
    @user.is_group_member? && @record.group_members.include?(@user)
  end

end
