# Taskable representing the times that all group members are available. As
# it uses only a subset of the events in the basic document submission
# workflow, it defines a custom workflow instead of using generalization.
#
# @author Brendan MacDonell
class OralPresentationForm < ActiveRecord::Base
  include AASM
  include Taskable

  aasm whiny_transitions: false do
    state :writing_submission, initial: true
    state :reviewing, enter: [:notify_submitted, :clear_users_who_accepted]
    state :accepted, after_enter: [:notify_accepted, :record_submission]

    event :submit do
      transitions from: [:writing_submission, :reviewing, :accepted],
                  to: :reviewing
    end

    event :accept do
      transitions from: :reviewing, to: :accepted,
                  guard: :all_users_accepted?
    end
  end

  serialize :accepted_user_ids, Set
  after_initialize :set_defaults

  def self.summarize(project: nil, **options)
    "Oral Presentation Form for #{project.name}"
  end

  def accept_for_user(user)
    accepted_user_ids << user.id
    accept!
  end

  def clear_users_who_accepted
    self.accepted_user_ids.clear
  end

  def accepted_users
    as_array = all_users.select { |user| accepted_user_ids.include?(user.id) }
    Set.new(as_array)
  end

  def pending_users
    all_users - accepted_users
  end

  def all_users_accepted?
    accepted_users == all_users
  end

  # Event transition actions:
  def notify_submitted
  end

  def notify_accepted
  end

  def record_submission
  end

  private

  def set_defaults
    self.accepted_user_ids ||= Set.new
    self.available_times ||= '[]'
  end

  # Returns a set of all users that are stakeholders on the project.
  def all_users
    Set.new(project.group_members + project.supervisors)
  end
end
