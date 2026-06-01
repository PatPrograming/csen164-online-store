module ApplicationHelper
  def stars_for(rating)
    return content_tag(:span, "No ratings yet", class: "muted") if rating.blank?

    full = rating.round
    filled = "★" * full
    empty = "☆" * (5 - full)
    content_tag(:span, "#{filled}#{empty} #{rating}", class: "stars")
  end

  def money(amount)
    number_to_currency(amount)
  end
end
