# Base task implementation that handles relationships to projects,
# and some summary information. Task uses multiple-table inheritance
# (MTI) to provide a table with summary information for all tasks that
# so that queries may be run without knowing the task type. To fetch the
# concrete object associated with the task, use {#taskable}.
#
# @author Brendan MacDonell
class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :taskable, polymorphic: true
  has_many :log_events

  validates :taskable, presence: true
  validates :summary, presence: true

  scope :pending, -> { where(completed_at: nil) }
  scope :completed, -> { where('completed_at is not null') }
end

# == Schema Information
#
# Table name: tasks
#
#  id            :integer          not null, primary key
#  project_id    :integer
#  taskable_type :string(255)
#  taskable_id   :integer
#  summary       :string(255)
#  deadline      :datetime
#  completed_at  :datetime
#

