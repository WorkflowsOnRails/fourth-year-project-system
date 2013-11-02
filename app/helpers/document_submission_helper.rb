module DocumentSubmissionHelper
  SUPERVISOR_REVIEWING_PARTIAL = 'document_submission/actions_supervisor_reviewing'
  MEMBER_WRITING_PARTIAL = 'document_submission/actions_member_writing_submission'

  def render_document_task_actions(taskable)
    state = taskable.aasm.current_state
    partial = nil

    # TODO: It would be nice if this was somehow tied into the authorization
    #       system instead of being totally disconnected and duplicating
    #       knowledge.
    if current_user.is_supervisor?
      if state == :reviewing
        partial = SUPERVISOR_REVIEWING_PARTIAL
      end
    elsif current_user.is_group_member?
      if state == :writing_submission or state == :reviewing
        partial = MEMBER_WRITING_PARTIAL
      end
    end

    if partial
      render partial: partial, locals: {taskable: taskable}
    end
  end
end
