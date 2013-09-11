module NavigationHelper
  def current_login(tab)
    render partial: 'layouts/login_logout', locals: {sign_in_tab:tab}
  end
end