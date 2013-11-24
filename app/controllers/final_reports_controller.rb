# @author Brendan MacDonell
class FinalReportsController < DocumentSubmissionController
  def find_taskable
    FinalReport.includes(:task).find(params[:id])
  end
end
