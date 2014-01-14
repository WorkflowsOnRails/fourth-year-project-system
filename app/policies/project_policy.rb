# @author Brendan MacDonell
class ProjectPolicy < ApplicationPolicy
  def show?
    true
  end

  def show_tasks?
    project.has_participant? user || user.is_coordinator?
  end

  def create?
    user.is_supervisor?
  end

  def update?
    user.is_coordinator? || user_supervises_project?
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

  alias_method :project, :record

  def user_supervises_project?
    project.has_supervisor? user
  end

end
