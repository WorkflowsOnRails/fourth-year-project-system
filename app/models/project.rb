# Work item that drives the process of completing a fourth year project.
# Transitions are linear; any processes with loops are carried out in the
# projects tasks. This allows us to model parallel activities without a
# combinatoric explosion of states.
#
# @author Brendan MacDonell
class Project < ActiveRecord::Base
  include StonePath::WorkItem

  has_many :tasks
  has_many :group_members, class_name: 'User'
  has_many :programmes
  has_and_belongs_to_many :supervisors, class_name: 'User'

  validates :name, presence: true
  validates :description, presence: true

  state_machine do
    state :writing_proposal, initial: true, after_enter: :create_proposal
    state :writing_progress_report, after_enter: :create_progress_report
    state :preparing_oral_presentation
    state :pending_completion, after_enter: :create_final_report
    state :completed

    event :select_project do
      transitions from: :suggested, to: :writing_proposal
    end

    event :accept_proposal do
      transitions from: :writing_proposal, to: :writing_progress_report
    end

    event :accept_progress_report do
      transitions from: :writing_progress_report,
                  to: :preparing_oral_presentation
    end

    event :finish_presentation do
      transitions from: :preparing_oral_presentation, to: :pending_completion
    end

    event :accept_final_report do
      transitions from: :pending_completion, to: :completed
    end
  end

  def create_proposal
    # TODO: Handle fetching deadlines from a configuration object
    Proposal.create(project: self, deadline: nil)
  end

  def create_progress_report
    # TODO: Handle fetching deadlines from a configuration object
    ProgressReport.create(project: self, deadline: nil)
  end

  def create_final_report
    # TODO: Handle fetching deadlines from a configuration object
    FinalReport.create(project: self, deadline: nil)
  end

  # TODO: Make this available as an AASM helper
  def signal_or_raise!(name, *args)
    saved = aasm_fire_event(name, {:persist => true}, *args)
    raise RuntimeError, "event transition failed!" unless saved
    nil
  end
end

# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  aasm_state  :string(255)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

