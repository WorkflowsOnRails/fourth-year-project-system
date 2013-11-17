# @author Brendan MacDonell
class FinalReportPolicy < DocumentSubmissionPolicy
  def deadline_expired?
    false  # This is a system action, not a user action.
  end
end
