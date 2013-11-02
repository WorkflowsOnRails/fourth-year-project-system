# Concrete task type that handles project proposal submissions.
# See {Task} for more information on the task hierarchy.
#
# @author Brendan MacDonell
class Proposal < ActiveRecord::Base
  include Taskable
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

  def self.summarize(project: nil, **options)
    "Proposal for #{project.name}"
  end

  private

  def notify_submitted
    # TODO
    puts "submitted"
  end

  def notify_returned
    # TODO
    puts "returned"
  end

  def notify_accepted
    # TODO
    puts "accepted"
  end

  def record_submission
    transaction do
      task.update_attributes(completed_at: DateTime.now)
      project_saved = project.accept_proposal!(nil, self)
      raise RuntimeError, "could not accept proposal" if not project_saved
    end
  end
end

# == Schema Information
#
# Table name: proposals
#
#  id         :integer          not null, primary key
#  aasm_state :string(255)
#

