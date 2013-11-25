# @author Brendan MacDonell
class OralPresentationFormPolicy < ApplicationPolicy
  alias_method :taskable, :record

  def show?
    taskable.project.has_participant?(user) ||
      user.is_coordinator?
  end

  def submit?
    taskable.project.has_participant?(user)
  end

  def accept?
    taskable.project.has_participant?(user) &&
      !taskable.accepted_users.include?(user)
  end
end
