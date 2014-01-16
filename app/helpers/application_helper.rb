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
      icon.concat(content_tag(:span,title,class:"text"))
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

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h5>#{sentence}</h5>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end



  def message_for_order(order)
    type = order.item_type
    partial = case type
                when "Wallet"
                  render partial: 'wallets/message',locals: {order:order}
                when "Airtime"
                  render partial: 'airtimes/message', locals:{order:order}
              end
  end

  def payment_form_for_order(order)
    type = order.item_type
    interswitch_params=map_order_to_interswitch_params(order)
    partial = case type
                when "Wallet"
                  render partial: 'wallets/payment_form',locals: {order:order,interswitch:interswitch_params}
                when "Airtime"
                  render partial: 'airtimes/payment_form', locals:{order:order,interswitch:interswitch_params}
              end
  end

  def json_message_partial_order(order)
    type = order.item_type
    case type
      when "Wallet"
        'api/v1/tokens/wallet_message'
      when "Airtime"
        'api/v1/tokens/credit_message'
    end
  end

  def class_for_status(status)
    case status
      when "success","payed"
        'success'
      when "processing","pending","confirmed"
        'warning'
      when "cancelled","failed"
        'error'
      else
        ""
    end
  end

  def label_class_for_status(status)
    case status
      when "success","payed"
        'success'
      when "processing","pending","confirmed"
        'warning'
      when "cancelled","failed"
        'important'
      else
        ""
    end
  end

  def paginate(controller,action,options = {})
    if paginate?
      content_tag(:div,raw("#{prev_page(controller,action)}#{page_info}#{next_page(controller,action)}"),class:"#{options[:class]}")
    end
  end

  def page_info
    pages= (@count.to_f/@per_page.to_f).ceil
    content_tag(:span,"#{@page}/#{pages}",class:'info')
  end

  def next_page(controller,action)
    link=nil
    if((@page*@per_page)<@count)
      url=url_for(
          :controller => controller,
          :action => action,
          :page => @page + 1,
          :per_page =>@per_page
      )
      link=raw("<a href='#{url}' class='btn'><i class='#{%q(icon-caret-right)}'></i></a> ")
    else
      link=raw("<a class='disabled btn'><i class='#{%q(icon-caret-right)}'></i></a> ")
    end
    content_tag(:div,link,class:'next')
  end

  def paginate?
    ((@page*@per_page)<@count||@page>1)
  end

  def prev_page(controller,action)
    link=nil
    if(@page>1)
      url=url_for(
          :controller => controller,
          :action => action,
          :page => @page - 1,
          :per_page =>@per_page
      )
      link=raw("<a href='#{url}' class='btn'><i class='#{%q(icon-caret-left)}'></i></a> ")
    else
      link=raw("<a  class='disabled btn'><i class='#{%q(icon-caret-left)}'></i></a> ")
    end
    content_tag(:div, link,class:'previous')
  end


  def download_for(platform)
    download_release_url(platform.os_name)
  end

  def options_from_collection_for_select_with_attributes(collection, value_method, text_method, attr_name, attr_field, selected = nil)
    options = collection.map do |element|
      [element.send(text_method), element.send(value_method), attr_name => element.send(attr_field)]
    end

    selected, disabled = extract_selected_and_disabled(selected)
    select_deselect = {}
    select_deselect[:selected] = extract_values_from_collection(collection, value_method, selected)
    select_deselect[:disabled] = extract_values_from_collection(collection, value_method, disabled)

    options_for_select(options, select_deselect)
  end

  def alert_for_payment_gateway(order)
    partial = case order.payment_processor.name
                when "interswitch"
                  render partial: 'application/interswitch_alert_info',locals: {order:order}
                when "wallet"
                  render partial: 'application/wallet_alert_info',locals: {order:order}
              end
  end


  def new_order
    order=Order.new
    order.item=Item.new
    order.item.itemable=current_user.wallet
    order.payment_processor=PaymentProcessor.new
    order
  end


  def  field_class(resource, field_name)
    logger.info "error present #{resource.errors[field_name]}"
       if resource.errors[field_name].present?
         return "error".html_safe
       else
         return "".html_safe
       end
  end

  def  error_html(resource, field_name)
    if resource.errors[field_name].present?
      return "<span class='help-inline'>#{resource.errors[field_name].join(" , ")}</span>".html_safe
    else
      return "".html_safe
    end
  end

  def payment_form_for_order(order)
    type = order.payment_processor.name
    partial = case type
                when "wallet"
                  render partial: 'application/wallet_pay_button',locals: {wallet: map_order_to_wallet_params(order),order:order}
                when "interswitch"
                  render partial: 'application/interswitch_pay_button',locals: {interswitch:map_order_to_interswitch_params(order,show_interswitch_order_status_url),order:order}
              end
  end

  def top_up_header(top_up)
    partial = case top_up.type
                when "PhoneNumberTopUp"
                  render partial: 'top_ups/phone_number_top_up_header',locals: {top_up: top_up}
                when "ContactTopUp"
                  render partial: 'top_ups/contact_top_up_header',locals: {top_up: top_up}
              end
  end

  def format_date_a(t)
    t.strftime("%m/%d/%Y")
  end
  def format_date_b(t)
    t.strftime("%A, %B %d %Y")
  end

  def format_date_c(t)
    t.strftime("%H:%M")
  end


  def order_item(order)
    partial = case order.item.itemable_type
                when "Wallet"
                  render partial: 'wallets/wallet_order',locals: {order:order}
                when "TopUp"
                  render partial: 'top_ups/top_up_order',locals: {order:order,top_up:order.item.itemable}
              end
  end
end
