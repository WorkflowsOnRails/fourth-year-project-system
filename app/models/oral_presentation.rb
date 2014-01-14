# Taskable that represents a scheduled oral presentation. There is no
# submission machinery associated with an oral presentation, only the time
# and location for which it is scheduled, plus the ability of the coordinator
# to edit the oral presentations if they must.
#
# @author Brendan MacDonell
class OralPresentation < ActiveRecord::Base
  include AASM
  include AasmProgressable::ModelMixin
  include Taskable

  validates :venue, presence: true
  validates :date, presence: true
  validates :start, presence: true
  validates :finish, presence: true

  before_destroy :destroy_task
  before_destroy :destroy_deadline

  aasm whiny_transitions: false do
    state :planning_presentation, initial: true
    state :completed, enter: :on_completed

    event :update_schedule do
      transitions from: :planning_presentation, to: :planning_presentation
    end

    event :deadline_expired do
      transitions from: :planning_presentation, to: :completed
    end
  end

  aasm_state_order [:planning_presentation, :completed]

  def self.summarize(project: nil, **options)
    "Oral Presentation for #{project.name}"
  end

  def destroy_task
    task.destroy
  end

  def destroy_deadline
    # Oral presentation deadlines are unique, so we don't want extras to
    #  accumulate if we schedule presentations many times.
    task.deadline.destroy
  end

  def on_completed
    project.finish_presentation
    mark_completed
  end

end

# == Schema Information
#
# Table name: oral_presentations
#
#  id         :integer          not null, primary key
#  aasm_state :string(255)
#  venue      :string(255)      not null
#  date       :date             not null
#  start      :time             not null
#  finish     :time             not null
#
