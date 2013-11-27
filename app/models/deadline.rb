class Deadline < ActiveRecord::Base
  self.primary_key = :code

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
end
