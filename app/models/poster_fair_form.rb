# Concrete task type handing poster fair demo forms. Any participant
# can submit (or edit and resubmit) the demo form, or retract submissions
# that they did not intend to make. Submissions and retractions are
# permitted until the form deadline expires.
#
# See {Task} for more information on the task hierarchy.
#
# @author Brendan MacDonell
class PosterFairForm < ActiveRecord::Base
  include AASM
  include Taskable

  aasm do
    state :not_submitted, initial: true, before_enter: :clear_requests
    state :submitted, after_enter: [:record_submission, :notify_submitted]
    state :closed, after_enter: [:record_submission]

    event :submit do
      transitions from: [:not_submitted, :submitted], to: :submitted
    end

    event :retract do
      transitions from: :submitted, to: :not_submitted,
                  on_transition: [:retract_submission, :notify_retracted]
    end

    event :deadline_expired do
      transitions from: [:not_submitted, :submitted], to: :closed
    end
  end

  with_options if: :submitted? do |m|
    m.validates :requests, presence: true
  end

  def self.summarize(project: nil, **options)
    "Poster Fair Form for #{project.name}"
  end

  # TODO:
  # * notify_submitted
  # * notify_retracted
  #
  # Should all models perform notifications last to prevent issues?

  private

  def notify_submitted
  end

  def notify_retracted
  end

  def clear_requests
    self.requests = ''
  end

  def record_submission
    task.update_attributes(completed_at: DateTime.now)
  end

  def retract_submission
    task.update_attributes(completed_at: nil)
  end
end
