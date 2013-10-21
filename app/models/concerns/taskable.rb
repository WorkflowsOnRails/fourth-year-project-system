# Mixin to support multiple-table inheritance of {Task}s. For more
# information, see {Task}.
#
# This mixin makes the model it is mixed into taskable, and exposes
# the task, project, deadline, and completed_at accessors.
#
# @author Brendan MacDonell
module Taskable
  extend ActiveSupport::Concern

  included do
    has_one :task, as: :taskable

    extend Forwardable
    def_delegators :task, :project, :deadline, :completed_at
  end
end
