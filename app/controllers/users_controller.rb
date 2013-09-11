class UsersController < ApplicationController
  def index
    if current_user.admin?
      @page=(params[:page]||1).to_i
      @per_page  = (params[:per_page] || 20).to_i
      @count=User.count
      @users = User.includes(:wallet).order("created_at desc").page(@page).per_page(@per_page).all

    else
      redirect_to root_url, alert: "Access denied"
    end
  end

  def show
    @user ||= User.find(params[:id])
    if current_user.can_edit?(@user)
      @user = User.find(params[:id])
    else
      render :text => 'Sorry you are not authorized to do that', :layout => true, :status => 401
    end
  end

  def home
  end

 def change_photo
    logger.info "successful upload..."
    respond_to do |format|
      if current_user.update_attribute("photo",params["photo"])
        format.html { redirect_to user_root_url, notice: 'Profile updated.' }
        format.json { render json: { :photo_url => current_user.photo.url(:thumb)}.to_json }
      else
        format.html { render action: "edit" }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def transactions
    @user ||= User.find(params[:id])
    if current_user.can_edit?(@user)
      @user = User.find(params[:id])
    else
      render :text => 'Sorry you are not authorized to do that', :layout => true, :status => 401
    end
  end

  def profile
    @user ||= User.find(params[:id])
    if current_user.can_edit?(@user)
      @user = User.find(params[:id])
    else
      render :text => 'Sorry you are not authorized to do that', :layout => true, :status => 401
    end
  end

  def edit
    @user ||= User.find(params[:id])
    if current_user.can_edit?(@user)
      @user = User.find(params[:id])
    else
      render :text => 'Sorry you are not authorized to do that', :layout => true, :status => 401
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :ok }
      else
        format.html {redirect_to @user}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
