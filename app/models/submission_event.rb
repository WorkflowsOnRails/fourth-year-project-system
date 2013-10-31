# TODO
#
# @author Brendan MacDonell
class SubmissionEvent < ActiveRecord::Base
  has_attached_file :attachment
  has_one :log_event, as: :details

  validates :attachment, attachment_presence: true

  # TODO: Factor this out
  def self.create(options = {})
    SubmissionEvent.transaction do
      task = options.delete(:task)
      user = options.delete(:user)
      details = super(options)
      LogEvent.create(
        user: user,
        task: task,
        details: details,
      )
      details
    end
  end
end
