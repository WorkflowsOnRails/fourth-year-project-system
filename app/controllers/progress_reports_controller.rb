class ProgressReportsController < ApplicationController
  include StateActionRenderable

  before_action :authenticate_user!

  def show
    @progress_report = find_progress_report()
    service = EventsService.new(@progress_report)
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

  def find_progress_report
    ProgressReport.includes(:task).find(params[:id])
  end
end
