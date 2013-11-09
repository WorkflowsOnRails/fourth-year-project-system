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

  def join?
    if @user.is_supervisor?
      !user_supervises_project?
    elsif @user.is_group_member?
      !group_member_in_project?
    end
  end

  def leave?
    if @user.is_supervisor?
      user_supervises_project?
    elsif @user.is_group_member?
      group_member_in_project?
    end
  end

  private

  def user_supervises_project?
    @user.is_supervisor? && @record.supervisors.include?(@user)
  end

  def group_member_in_project?
    @user.is_group_member? && @record.group_members.include?(@user)
  end

end
