module UsersHelper
  def avatar_present?
    current_user.persisted? && current_user.avatar.attached?
  end
end
