class SchedulingRequestPolicy < ApplicationPolicy
  def show?
    user.is_coordinator? # && deadline_expired?
  end

  alias_method :create?, :show?

  private

  def deadline_expired?
    Deadline
      .find_for_task_type(OralPresentationForm)
      .try(:timestamp)
      .try(:<, DateTime.now)
  end
end
