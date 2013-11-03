module ApplicationHelper
  # Returns a bootstrap alert CSS class appropriate for a flash level
  # @author Brendan MacDonell
  FLASH_CLASSES = {
    :notice => "alert-info",
    :success => "alert-success",
    :alert => "alert-warning",
    :error => "alert-danger",
  }
  FLASH_CLASSES.default = "alert-info"

  def flash_class(level)
    FLASH_CLASSES[level]
  end

  # Helper that outputs "active" if a controller is active, or an
  # empty string otherwise. Used to flag navigation links active
  # when the controller they correspond to is visited.
  #
  # @author Brendan MacDonell
  def nav_class_for_controller(*controller)
    is_active = controller.include?(params[:controller])
    is_active ? "active" : ""
  end

  # Render a datetime into a format useable by jquery.localtime
  # @author Brendan MacDonell
  def render_datetime(dt)
    return nil if dt.nil?
    # Don't worry about XSS here; ISO8601 formatting is safe
    "<span data-localtime-format>#{dt.iso8601}</span>".html_safe
  end
end
