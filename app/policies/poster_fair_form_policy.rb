# @author Brendan MacDonell
class PosterFairFormPolicy < ApplicationPolicy

  alias_method :taskable, :record

  def show?
    true
  end

  def submit?
    user_participanting_in_project?
  end

  alias_method :retract?, :submit?

  def deadline_expired?
    false  # this event is triggered by a scheduled task
  end

  private

  def user_participanting_in_project?
    taskable.project.has_participant?(user)
  end

end
