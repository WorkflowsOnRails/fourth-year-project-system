class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def configure_permitted_parameters
    extra_params = [:full_name, :programme, :student_number]
    devise_parameter_sanitizer.for(:sign_up).push(*extra_params)
    devise_parameter_sanitizer.for(:account_update).push(*extra_params)
  end

  def build_resource(hash = nil)
    super(hash)
    resource.role = User::GROUP_MEMBER_ROLE
  end
end
