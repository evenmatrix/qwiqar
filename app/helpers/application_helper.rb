module ApplicationHelper
  def nav_tab(title, url, options = {})
    current_tab = options.delete(:current)
    options[:class] = (current_tab == title) ? 'active' : ''
    label=nil
    icon=nil
    link=""
    icon_class=options.delete(:icon)
    if icon_class
      icon= content_tag(:i, "",class:"#{icon_class[:class]}")
    end
    link= link_to url do
      content_tag(:span,icon.concat(" #{title}"),class:"text")
    end
    content_tag(:li,link,options)
  end

  def currently_at_side_nav(tab)
    render partial: 'layouts/side_nav', locals: {current_tab: tab}
  end

  def active_tab(title, url, options = {})
    current_tab = options.delete(:current)
    options[:active_class] = (current_tab == title) ? 'active' : ''
    options[:title] = title
    options[:url] = url
    options
  end
end
