require 'test_helper'

class ProjectLifecycleTest < ActiveSupport::TestCase
  include TestHelper
  include TestHelper::Users

  setup :setup_project
  teardown :teardown_project

  DEADLINES = {
    Proposal => DateTime.new(2013, 9, 21),
    ProgressReport => DateTime.new(2013, 12, 9),
    OralPresentationForm => DateTime.new(2013, 12, 9),
    PosterFairForm => DateTime.new(2014, 3, 1),
    FinalReport => DateTime.new(2014, 4, 9),
  }

  def setup_project
    Timecop.freeze(DateTime.new(2013, 8, 1))
    DEADLINES.each { |klass, timestamp| set_deadline klass, timestamp }

    @project = create(:project)
    @student.join_project @project
    @coordinator.join_project @project
  end

  def teardown_project
    Timecop.return
  end

  test 'proposal transition coverage' do
    PROPOSAL_NAME = "Proposal for #{@project.name}"
    PROGRESS_REPORT_NAME = "Progress Report for #{@project.name}"
    FILENAME = File.expand_path(__FILE__)
    FILENAME_SUBMITTED_MESSAGE = "submitted #{File.basename FILENAME}"
    RESUBMISSION_COMMENT = 'Sorry, the first submission was wrong'
    RETURN_COMMENT = 'Sorry, I think this is still the wrong file'

    using_session :student do
      login_student
      click_on PROPOSAL_NAME

      assert state_is_writing_submission?

      # Submit initial version
      within '#action-submit' do
        attach_file 'New Submission', FILENAME
        click_on 'Submit'
      end

      assert state_is_reviewing?
      assert page.has_content?(FILENAME_SUBMITTED_MESSAGE)

      # Resubmit to correct errors
      within '#action-submit' do
        fill_in 'submission_event_comment', with: RESUBMISSION_COMMENT
        attach_file 'New Submission', FILENAME
        click_on 'Submit'
      end

      assert state_is_reviewing?
      assert page.has_content?(RESUBMISSION_COMMENT)
    end

    using_session :coordinator do
      login_coordinator
      click_on PROPOSAL_NAME

      # Return the proposal with a comment
      within '#action-return' do
        fill_in 'feedback_event_comment', with: RETURN_COMMENT
        click_on 'Return Submission'
      end

      assert state_is_writing_submission?
      assert page.has_content?(RETURN_COMMENT)
    end

    using_session :student do
      refresh_page
      assert state_is_writing_submission?

      # Submit a fixed version of the proposal
      within '#action-submit' do
        attach_file 'New Submission', FILENAME
        click_on 'Submit'
      end
    end

    using_session :coordinator do
      refresh_page
      assert state_is_reviewing?

      # Accept the fixed version of the proposal
      within '#action-accept' do
        click_on 'Accept Submission'
      end

      assert state_is_completed?
    end

    using_session :student do
      refresh_page
      assert state_is_completed?

      # Check that the following tasks have become available
      visit '/'
      assert page.has_content?(PROGRESS_REPORT_NAME)
    end
  end

  test 'progress report transition coverage' do
  end

  private

  def state_is?(text)
    page.has_selector?('li.active', text: text)
  end

  def state_is_writing_submission?
    state_is? '1. Writing submission'
  end

  def state_is_reviewing?
    state_is? '2. Reviewing'
  end

  def state_is_completed?
    state_is? '3. Completed'
  end

  def set_deadline(klass, timestamp)
    deadline = Deadline.find_or_initialize_by_task_type(klass)
    deadline.timestamp = timestamp
    deadline.save!
  end
end
