# @author Brendan MacDonell
class ProgressReportsController < DocumentSubmissionController
  def find_taskable
    ProgressReport.includes(:task).find(params[:id])
  end
end
