module ReviewsHelper
  def roasted_select_box
    %w[ライトロースト シナモンロースト ミディアムロースト ハイロースト シティロースト フルシティロースト フレンチロースト イタリアンロースト]
  end

  def grind_select_box
    %w[極細挽き 細挽き 中細挽き 中挽き 粗挽き]
  end

  def default_value(value)
    (value ||= 1).to_s
  end

  def straight_or_blend_tag(review)
    if review.blend
      content_tag(:span, 'ブレンド', class: 'badge badge-secondary tag-blend')
    else
      content_tag(:span, 'ストレート', class: 'badge badge-secondary tag-straight')
    end
  end

  # レビューに添付された画像の有無で表示を切り替える
  def image_presence?(object, options = {})
    if object.image.attached?
      ActionController::Base.helpers.image_tag object_url(object.image), options
    else
      ActionController::Base.helpers.image_tag 'no_image.jpg', options
    end
  end
end
