# TODO
#
# @author Brendan MacDonell
class LogEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :details, polymorphic: true

  scope :chronological, -> { order('created_at desc') }
end
