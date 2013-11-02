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
      # TODO: Validation if details are rejected
      LogEvent.create(
        user: user,
        task: task,
        details: details,
      )
      details
    end
  end
end

# == Schema Information
#
# Table name: submission_events
#
#  id                      :integer          not null, primary key
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  comment                 :text
#  created_at              :datetime
#  updated_at              :datetime
#

