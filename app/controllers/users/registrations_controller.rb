# Registration controller for Group Members. Supervisors and Coordinators
# are created through different interfaces, so we need to make sure that
# the controller automatically marks every user created through this
# controller with the appropriate role.
#
# @author Brendan MacDonell
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  # Group Members must be able to set their full name, programme, and
  # student number, while other roles only need to be able to set
  # their full name. This method allows the union of these parameter
  # sets, as the view won't display the extra paremeters, nor will the
  # model accept them.
  def configure_permitted_parameters
    extra_params = [:full_name, :programme, :student_number]
    devise_parameter_sanitizer.for(:sign_up).push(*extra_params)
    devise_parameter_sanitizer.for(:account_update).push(*extra_params)
  end

  # Overload build_resource to ensure that users created through this
  # controller are registered as Group Members. build_resource handles
  # creating users for the new and create actions, so we don't need to worry
  # about corrupting accounts for other roles herer.
  def build_resource(hash = nil)
    super(hash)
    resource.role = User::GROUP_MEMBER_ROLE
  end
end
