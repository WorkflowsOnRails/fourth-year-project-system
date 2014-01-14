# @author Brendan MacDonell
class OralPresentationFormPolicy < BaseTaskPolicy
  def submit?
    user_participates_in_project?
  end

  def accept?
    user_participates_in_project? && !taskable.accepted_users.include?(user)
  end
end
