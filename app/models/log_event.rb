# TODO
#
# @author Brendan MacDonell
class LogEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :details, polymorphic: true

  scope :chronological, -> { order('created_at desc') }
end

# == Schema Information
#
# Table name: log_events
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  task_id      :integer          not null
#  details_id   :integer          not null
#  details_type :string(255)      not null
#  created_at   :datetime
#

