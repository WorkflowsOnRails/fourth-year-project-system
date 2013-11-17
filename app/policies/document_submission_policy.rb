# @author Brendan MacDonell
class DocumentSubmissionPolicy < ApplicationPolicy

  def show?
    true
  end

  def submit?
    user_member_of_project?
  end

  def accept?
    user_supervises_project?
  end

  def return?
    user_supervises_project?
  end

  private

  alias_method :taskable, :record

  def project
    taskable.project
  end

  def user_supervises_project?
    project.supervisors.include?(user)
  end

  def user_member_of_project?
    project.group_members.include?(user)
  end

end
