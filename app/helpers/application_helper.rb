module ApplicationHelper
  def current_user?(klass)
    klass.user == current_user
  end
end
