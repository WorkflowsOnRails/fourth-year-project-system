class FinalReport < ActiveRecord::Base
  include DocumentSubmissionWorkflow
  include Taskable

  aasm do
    state :failed

    event :deadline_expired do
      after { notify_expired }

      transitions from: :writing_submission, to: :failed
      transitions from: :reviewing, to: :accepted
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

  # TODO: Will there by any use in factoring this out?
  def record_submission
    transaction do
      task.update_attributes(completed_at: DateTime.now)
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

