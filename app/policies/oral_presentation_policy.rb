# @author Brendan MacDonell
class OralPresentationPolicy < ApplicationPolicy
  alias_method :taskable, :record

  def show?
    taskable.project.has_participant?(user) ||
      user.is_coordinator?
  end

  def update?
    user.is_coordinator?
  end

  def deadline_expired?
    false  # This is a system action, the user can't perform it.
  end

end
