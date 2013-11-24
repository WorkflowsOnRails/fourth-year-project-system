class ProposalsController < DocumentSubmissionController
  def find_taskable
    Proposal.find(params[:id])
  end
end
