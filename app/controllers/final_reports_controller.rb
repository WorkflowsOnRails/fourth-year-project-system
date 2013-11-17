# TODO: Pull all of the guts into a superclass, rename
#       the specific object to @taskable? Share a common
#       layout?
#
# @author Brendan MacDonell
class FinalReportsController < ApplicationController
  include StateActionRenderable

  before_action :authenticate_user!

  def show
    @final_report = find_final_report()
    service = EventsService.new(@final_report)
    @last_submission_event = service.last_submission_event
    @log_events = service.events.paginate(page: params[:page], per_page: 10)
  end

  def action_view_prefix(event)
    'document_submission'
  end

  # TODO: Fix possible responses to submissions on other tasks.
  # TODO: Fix n queries when rendering feedback events.
  # TODO: Fix poor page layout.

  private

  def find_final_report
    FinalReport.includes(:task).find(params[:id])
  end
end
