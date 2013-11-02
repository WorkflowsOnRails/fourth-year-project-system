# Concrete task type that handles project proposal submissions.
# See {Task} for more information on the task hierarchy.
#
# @author Brendan MacDonell
class Proposal < ActiveRecord::Base
  include DocumentSubmissionWorkflow
  include Taskable

  def self.summarize(project: nil, **options)
    "Proposal for #{project.name}"
  end

  private

  # TODO:
  # * notify_submitted
  # * notify_accepted
  # * notify_returned

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

