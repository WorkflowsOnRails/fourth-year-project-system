# Base task implementation that handles relationships to projects,
# and some summary information. Task uses multiple-table inheritance
# (MTI) to provide a table with summary information for all tasks that
# so that queries may be run without knowing the task type. To fetch the
# concrete object associated with the task, use {#taskable}.
#
# @author Brendan MacDonell
class Task < ActiveRecord::Base
  include Expirable

  belongs_to :project
  belongs_to :deadline
  belongs_to :taskable, polymorphic: true
  has_many :log_events

  validates :deadline, presence: true
  validates :taskable, presence: true
  validates :summary, presence: true

  default_scope { includes(:deadline) }

  scope :pending, -> { where(completed_at: nil) }
  scope :completed, -> { where('completed_at is not null') }
  scope :overdue, -> {
    joins(:deadline)
      .where(completed_at: nil)
      .where('deadlines.timestamp < ?', DateTime.now)
  }
  scope :newly_expired, -> { overdue.where(expired_at: nil) }
  scope :late, -> {
    joins(:deadline).where('completed_at > deadlines.timestamp')
  }

  scope :by_completion_date, -> { order(:completed_at) }

  def self.by_deadline
    joins(:deadline).order('deadlines.timestamp')
  end

  def completed?
    completed_at.present?
  end

  def overdue?
    completed_at.nil? && deadline.timestamp < DateTime.now
  end

  def late?
    completed_at.present? && completed_at > deadline.timestamp
  end

  def mark_completed
    if completed_at.nil?
      update_attributes(completed_at: DateTime.now)
    end
  end

  def deadline_expired
    taskable.try(:deadline_expired!)
    update_attributes(expired_at: DateTime.now)
  end
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

