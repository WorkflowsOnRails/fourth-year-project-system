module ApplicationHelper
  # Helper that outputs "active" if a controller is active, or an
  # empty string otherwise. Used to flag navigation links active
  # when the controller they correspond to is visited.
  #
  # @author Brendan MacDonell
  def nav_class_for_controller(*controller)
    is_active = controller.include?(params[:controller])
    is_active ? "active" : ""
  end
end
