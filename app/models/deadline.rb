class Deadline < ActiveRecord::Base
  self.primary_key = :code

  validates :timestamp, presence: true
  validate :timestamp_cannot_be_in_the_past

  def self.find_for_task_type(type)
    Deadline.find(code_for_task_type(type))
  end

  def self.find_or_initialize_by_task_type(type)
    Deadline.find_or_initialize_by(code: code_for_task_type(type))
  end

  private

  def self.code_for_task_type(type)
    type.name
  end

  def timestamp_cannot_be_in_the_past
    if timestamp && timestamp < DateTime.now
      errors.add(:timestamp, "can't be in the past")
    end
  end
end
