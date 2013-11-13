module UsersHelper
  def currently_at_people_nav(tab)
    render partial: 'users/people/people_nav', locals: {current_tab: tab}
  end

  def people_nav_item(title, url, options = {})
    render partial: 'users/people/people_nav_item', locals: {data: active_tab(title, url, options)}
  end
end
