# Work item that drives the process of completing a fourth year project.
# Transitions are linear; any processes with loops are carried out in the
# projects tasks. This allows us to model parallel activities without a
# combinatoric explosion of states.
#
# @author Brendan MacDonell
class Project < ActiveRecord::Base
  include StonePath::WorkItem

  has_many :tasks

  validates :name, presence: true
  validates :description, presence: true

  state_machine do
    state :suggested, initial: true
    state :writing_proposal, after_enter: :create_proposal_task
    state :writing_progress_report
    state :preparing_oral_presentation
    state :pending_completion
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

  def create_proposal_task
    # TODO: Handle fetching deadlines from a configuration object
    Proposal.create(project: self, deadline: nil)
  end
end
