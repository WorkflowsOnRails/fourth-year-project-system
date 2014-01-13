# TODO
#
# @author Brendan MacDonell
class SchedulingRequest
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Serialization

  validates :date_in_week, :day_start_time, :day_end_time, presence: true
  attr_accessor :date_in_week, :day_start_time, :day_end_time
end
