class FinalReport < ActiveRecord::Base
  include DocumentSubmissionWorkflow
  include Taskable

  aasm do
    event :deadline_expired do
      after { notify_expired }

      transitions from: :writing_submission, to: :failed,
                  on_transition: :mark_completed
      transitions from: :reviewing, to: :accepted,
                  on_transition: :on_accepted
      transitions from: :accepted, to: :accepted
    end
  end

  def self.summarize(project: nil, **options)
    "Final Report for #{project.name}"
  end

  private

  # TODO:
  # * notify_accepted
  # * notify_expired
  # * notify_submitted
  # * notify_returned

  def notify_expired
  end

  def record_submission
    transaction do
      mark_completed
      project.signal_or_raise!(:accept_final_report, nil, self)
    end
  end
end

# == Schema Information
#
# Table name: final_reports
#
#  id         :integer          not null, primary key
#  aasm_state :string(255)
#

