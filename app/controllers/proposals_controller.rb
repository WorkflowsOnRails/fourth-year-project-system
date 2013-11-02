class ProposalsController < ApplicationController
  before_action :authenticate_user!

  def show
    @proposal = find_proposal()
    service = EventsService.new(@proposal)
    @last_submission_event = service.last_submission_event
    @log_events = service.events.paginate(page: params[:page], per_page: 10)
  end

  # TODO: Fix possible responses to submissions on other tasks.
  # TODO: Fix n queries when rendering feedback events.
  # TODO: Fix poor page layout.

  private

  def find_proposal
    Proposal.find(params[:id])
  end
end
