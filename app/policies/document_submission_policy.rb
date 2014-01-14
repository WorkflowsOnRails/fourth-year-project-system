# @author Brendan MacDonell
class DocumentSubmissionPolicy < BaseTaskPolicy

  def submit?
    user_member_of_project?
  end

  def accept?
    user_supervises_project?
  end

  def return?
    user_supervises_project?
  end

end
