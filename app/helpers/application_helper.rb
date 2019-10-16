module ApplicationHelper
  def current_user?(klass)
    klass.user == current_user
  end


  # ユーザー画像が設定されていない場合にデフォルト画像を表示する
  def avatar_attached?(user)
    if user.avatar.attached?
      ActionController::Base.helpers.image_tag(object_url(user.avatar))
    else
      ActionController::Base.helpers.image_tag('avatar_no_image.jpg')
    end
  end

  # production環境でS3オブジェクトのURLを取得するためのメソッド
  def object_url(object_image)
    if Rails.env.production?
      object_image.attachment.service.send(:object_for, object_image.key).public_url
    else
      url_for(object_image)
    end
  end

  # ヘッダーアイコンのリンク先をログイン前後で変更するため
  def header_icon_url
    user_signed_in? ? reviews_path : root_path
  end

  # 必須入力項目に表示されるバッジ
  def requier_badge
    content_tag :span, '必須', class: 'badge badge-danger ml-1'
  end
end