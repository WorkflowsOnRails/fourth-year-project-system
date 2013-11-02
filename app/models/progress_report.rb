# Concrete task type that handles progress report submissions.
# See {Task} for more information on tasks.
#
# @author Brendan MacDonell
class ProgressReport < ActiveRecord::Base
  include DocumentSubmissionWorkflow
  include Taskable

  def self.summarize(project: nil, **options)
    "Progress Report for #{project.name}"
  end

  private

  # TODO:
  # * notify_submitted
  # * notify_accepted
  # * notify_returned

  # TODO: Will there by any use in factoring this out?
  def record_submission
    transaction do
      task.update_attributes(completed_at: DateTime.now)
      project_saved = project.accept_progress_report!(nil, self)
      raise RuntimeError, "could not accept progress" unless project_saved
    end
  end
end
