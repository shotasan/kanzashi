module UsersHelper
  def avatar_present?
    current_user.persisted? && current_user.avatar.attached?
  end

  def guest_email
    'guest@sample.com'
  end

  def guest_password
    'guestuser'
  end

  def guest?
    current_user.email == guest_email
  end
end
