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
  include AasmProgressable::ModelMixin
  include Taskable

  aasm do
    state :not_submitted, initial: true, before_enter: :clear_requests
    state :submitted, after_enter: [:mark_completed, :notify_submitted]
    state :closed, after_enter: :mark_completed_at_deadline

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

  aasm_state_order [:not_submitted, :submitted, :closed]

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

  def retract_submission
    task.update_attributes(completed_at: nil)
  end
end

# == Schema Information
#
# Table name: poster_fair_forms
#
#  id         :integer          not null, primary key
#  aasm_state :string(255)
#  requests   :text
#
