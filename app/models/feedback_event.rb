# TODO
#
# @author Brendan MacDonell
class FeedbackEvent < ActiveRecord::Base
  include LogEventable

  belongs_to :submission_event

  def fire_events!(task)
    if accepted
      task.taskable.accept!
    else
      task.taskable.return!
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
# Indexes
#
#  index_feedback_events_on_submission_event_id  (submission_event_id)
#
