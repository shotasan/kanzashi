module ApplicationHelper
  def current_user?(klass)
    klass.user == current_user
  end

  def object_url(object_image)
    if Rails.env.test?
      object_image
    else
      object_image.attachment.service.send(:object_for, object_image.key).public_url
    end
  end
end
