# Base class for policies for tasks. It provides a sufficient default show?
# method to ensure that only users who should see a task can do so, along with
# a collection of helper aliases and predicates.
#
# @author Brendan MacDonell
class BaseTaskPolicy < ApplicationPolicy
  def show?
    user_participates_in_project? || user.is_coordinator?
  end

  private

  alias_method :taskable, :record

  def project
    taskable.project
  end

  def user_participates_in_project?
    project.has_participant? user
  end

  def user_supervises_project?
    project.has_supervisor? user
  end

  def user_member_of_project?
    project.has_group_member? user
  end
end
