class ProposalsController < ApplicationController
  before_action :authenticate_user!

  SUBMISSION_TYPE = SubmissionEvent.name

  def show
    @proposal = find_proposal()
    log_events = @proposal.task.log_events.includes(:details).chronological
    submission_events = log_events.where(details_type: SUBMISSION_TYPE)
    @last_submission_event = submission_events.first.details
    @log_events = log_events.paginate(page: params[:page], per_page: 10)
  end

  # TODO: Fix poor page layout.

  private

  def find_proposal
    Proposal.find(params[:id])
  end
end
