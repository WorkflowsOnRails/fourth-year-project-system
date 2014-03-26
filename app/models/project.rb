# Work item that drives the process of completing a fourth year project.
# Transitions are linear; any processes with loops are carried out in the
# projects tasks. This allows us to model parallel activities without a
# combinatoric explosion of states.
#
# @author Brendan MacDonell
class Project < ActiveRecord::Base
  include StonePath::WorkItem
  include AasmProgressable::ModelMixin

  has_many :tasks, dependent: :destroy
  has_many :group_members, class_name: 'User'
  has_many :programmes, dependent: :destroy
  has_and_belongs_to_many :supervisors, class_name: 'User'

  validates :name, presence: true
  validates :description, presence: true

  state_machine do
    state :writing_proposal, initial: true, after_enter: :create_proposal
    state :writing_progress_report,
          after_enter: [:create_progress_report, :create_oral_presentation_form]
    state :preparing_oral_presentation
    # TODO: Allow coordinator to create view_oral_presentation_schedule tasks
    # TODO: Add view poster fair task to pending_completion
    state :pending_completion,
          after_enter: [:create_poster_fair_form, :create_final_report]
    state :completed, final: true

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

  aasm_state_order [:writing_proposal,
                    :writing_progress_report,
                    :preparing_oral_presentation,
                    :pending_completion,
                    :completed]

  def has_group_member?(user)
    user.is_group_member? && group_members.include?(user)
  end

  def has_supervisor?(user)
    user.is_supervisor? && supervisors.include?(user)
  end

  def has_participant?(user)
    has_group_member?(user) || has_supervisor?(user)
  end

  def create_proposal
    create_taskable(Proposal)
  end

  def create_progress_report
    create_taskable(ProgressReport)
  end

  def create_oral_presentation_form
    create_taskable(OralPresentationForm)
  end

  def create_poster_fair_form
    create_taskable(PosterFairForm)
  end

  def create_final_report
    create_taskable(FinalReport)
  end

  # TODO: Make this available as an AASM helper
  def signal_or_raise!(name, *args)
    saved = aasm_fire_event(name, {:persist => true}, *args)
    raise RuntimeError, "event transition failed!" unless saved
    nil
  end

  private

  def create_taskable(type)
    deadline = Deadline.find_for_task_type(type)
    type.create(project: self, deadline: deadline)
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

