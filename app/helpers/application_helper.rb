module ApplicationHelper
  include Rails.application.routes.url_helpers

  def current_user?(klass)
    klass.user == current_user
  end
end
