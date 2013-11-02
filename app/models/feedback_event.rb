# TODO
#
# @author Brendan MacDonell
class FeedbackEvent < ActiveRecord::Base
  belongs_to :submission_event
  has_one :log_event, as: :details

  # TODO: Factor this out
  def self.create(options = {})
    FeedbackEvent.transaction do
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

# == Schema Information
#
# Table name: feedback_events
#
#  id                  :integer          not null, primary key
#  submission_event_id :integer          not null
#  accepted            :boolean          not null
#  comment             :text
#  created_at          :datetime
#  updated_at          :datetime
#

