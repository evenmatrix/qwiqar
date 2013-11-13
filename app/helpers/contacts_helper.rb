module ContactsHelper
  def currently_at_contact_nav(tab)
    render partial: 'contacts/links', locals: {action: tab}
  end
end
