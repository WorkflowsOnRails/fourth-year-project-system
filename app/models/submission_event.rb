# Log event representing the submission of a document, possibly with
# an associated comment.
#
# @author Brendan MacDonell
class SubmissionEvent < ActiveRecord::Base
  include LogEventable

  has_attached_file :attachment

  validates :attachment, attachment_presence: true

  def fire_events!(task)
    task.taskable.submit!
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

