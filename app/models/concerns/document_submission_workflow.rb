# Concern for a generic document submission workflow.
#
# Classes mixin in this workflow may implement the following methods:
# * notify_submitted
# * notify_accepted
# * notify_returned
# * record_submission
#
# Implementors may also extend the workflow by re-opening aasm using
# `aasm do ... end`.
#
# @author Brendan MacDonell
module DocumentSubmissionWorkflow
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :writing_submission, initial: true
      state :reviewing, enter: :notify_submitted
      state :accepted, after_enter: [:notify_accepted, :record_submission]

      event :submit do
        transitions from: [:writing_submission, :reviewing], to: :reviewing
      end

      event :return do
        transitions from: :reviewing, to: :writing_submission,
                    on_transition: :notify_returned
      end

      event :accept do
        transitions from: :reviewing, to: :accepted
      end
    end
  end

  def notify_submitted
  end

  def notify_accepted
  end

  def notify_returned
  end

  def record_submission
  end
end
