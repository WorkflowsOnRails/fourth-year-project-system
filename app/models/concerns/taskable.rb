# Mixin to support multiple-table inheritance of {Task}s. For more
# information, see {Task}.
#
# This mixin makes the model it is mixed into taskable, and exposes
# the task, project, deadline, and completed_at accessors.
#
# Models mixing in Taskable should implement self.summarize, which
# takes the parameter hash passed to {#create} as arguments and produces
# a summary string describing the task.
#
# @author Brendan MacDonell
module Taskable
  extend ActiveSupport::Concern

  included do
    has_one :task, as: :taskable
    has_one :project, through: :task

    extend Forwardable
    def_delegators :task, :deadline, :completed_at, :mark_completed,
                   :completed?, :late?, :overdue?
  end

  module ClassMethods
    # Manages creating the linked task and taskable at the same time.
    def create(**options)
      all_options = options.clone
      project = options.delete(:project)
      deadline = options.delete(:deadline)
      transaction do
        taskable = super(options)
        Task.create(
          project: project,
          taskable: taskable,
          summary: summarize(all_options),
          deadline: deadline,
        )
        taskable
      end
    end
  end
end
