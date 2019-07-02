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
end
