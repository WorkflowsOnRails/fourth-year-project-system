# @author Alexander Clelland

require 'test_helper'

class SupervisorTest < ActiveSupport::TestCase
  include TestHelper
  include TestHelper::Users

  test "create a supervisor and delete it" do
    supervisor_attrs = attributes_for(:supervisor)

    visit '/'
    login_coordinator

    click_on 'Administration'
    click_on 'Manage Supervisors'
    click_on 'Create Supervisor Account'

    within '#new_user' do
      fill_in 'Full name', with: supervisor_attrs[:full_name]
      fill_in 'Email', with: supervisor_attrs[:email]
      fill_in 'Password', with: supervisor_attrs[:password], match: :prefer_exact
      fill_in 'Password confirmation', with: supervisor_attrs[:password]
      click_on 'Create'
    end

    assert page.has_content? 'Supervisor created successfully'

    click_on 'Administration'
    click_on 'Manage Supervisors'

    row_xpath = "//tr[contains(.,'#{supervisor_attrs[:full_name]}')]"
    find(:xpath, row_xpath).click_on('Delete')

    assert page.has_content? 'Supervisor deleted successfully'
  end

end
