# TODO: Document this
#
# @author Brendan MacDonell
class DocumentSubmissionController < ApplicationController
  include AasmActionable::ControllerMixin

  before_action :authenticate_user!

  def show
    @taskable = find_taskable()
    authorize @taskable
    service = EventsService.new(@taskable)
    @last_submission_event = service.last_submission_event
    @log_events = service.events.paginate(page: params[:page], per_page: 10)
  end

  def action_view_prefix(event)
    'document_submission'
  end

  # TODO: Fix possible responses to submissions on other tasks.
  # TODO: Fix n queries when rendering feedback events.
  # TODO: Fix poor page layout.

  def submit
    @taskable = find_taskable()
    authorize @taskable

    event_params = params
      .require(:submission_event)
      .permit(:comment, :attachment)

    event = SubmissionEvent.make(current_user, @taskable.task, event_params)
    rerender_or_redirect(event.valid?)
  end

  # Handles both `accept` and `return` actions by the end user.
  def handle_feedback
    @taskable = find_taskable()
    authorize @taskable

    event_params = params
      .require(:feedback_event)
      .permit(:accepted, :comment, :submission_event_id)

    event = FeedbackEvent.make(current_user, @taskable.task, event_params)
    rerender_or_redirect(event.valid?)
  end

  alias_method :accept, :handle_feedback
  alias_method :return, :handle_feedback

  def rerender_or_redirect(is_valid)
    resource_name = @taskable.class.model_name.human
    options = {
      resource_name: resource_name,
      downcase_resource_name: resource_name.downcase,
    }
    if is_valid
      flash[:notice] = t(:"flash.actions.#{action_name}.notice", options)
      redirect_to @taskable
    else
      flash[:alert] = t(:"flash.actions.#{action_name}.alert", options)
      show # TODO: Validation errors
      render 'show'
    end
  end
end
