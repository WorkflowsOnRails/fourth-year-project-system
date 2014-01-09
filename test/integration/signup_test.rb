# TODO
#
# @author Brendan MacDonell

require 'test_helper'

class SignupTest < ActiveSupport::TestCase
  include TestHelper

  test "create a student account" do
    user_attrs = attributes_for(:user)

    visit '/'
    click_on 'Sign up'

    within '#new_user' do
      fill_in 'Full name', with: user_attrs[:full_name]
      fill_in 'Student number', with: user_attrs[:student_number]
      select user_attrs[:programme], from: 'Programme'
      fill_in 'Email', with: user_attrs[:email]
      fill_in 'Password', with: user_attrs[:password], match: :prefer_exact
      fill_in 'Password confirmation', with: user_attrs[:password]
      click_on 'Sign up'
    end

    assert page.has_content? 'You have signed up successfully'
    assert page.has_content? 'Your Tasks'
  end
end
