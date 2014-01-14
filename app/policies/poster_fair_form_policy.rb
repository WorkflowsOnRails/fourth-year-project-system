# @author Brendan MacDonell
class PosterFairFormPolicy < BaseTaskPolicy

  def submit?
    user_participates_in_project?
  end

  alias_method :retract?, :submit?

  def deadline_expired?
    false  # this event is triggered by a scheduled task
  end

end
