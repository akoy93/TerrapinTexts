module ApplicationHelper
  def full_title(page_title, base_title)
    if page_title.empty? || page_title == "Home"
      base_title
    else
      base_title + " | " + page_title
    end
  end

  def get_menu_showing_current(menu_option, page_title)
    result = menu_option.match(/\>(\w+)\</)
    if result && result[1] == page_title
      "<li class=\"active\">#{menu_option}</li>"
    else
      "<li>#{menu_option}</li>"
    end
  end

  def condition_to_s(i)
    conditions = ["Poor", "Fair", "Good", "Very Good", "Like New"]
    conditions[i.to_i * -1]
  end
end
