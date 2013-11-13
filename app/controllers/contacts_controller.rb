class ContactsController < ApplicationController

  def search
    @user = User.find(params[:user_id])
    if @user
    query=params[:q]
    @results = @user.contacts.where("first_name LIKE ? OR last_name LIKE ?", "%#{query}%","%#{query}%").order(:first_name).order(:last_name)
    respond_to do |format|
      format.json
      format.js
    end
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def index
    @user = User.find(params[:user_id])
    if @user
      @page=(params[:page]||1).to_i
      @per_page = (params[:per_page] || 10).to_i
      @per_page=@per_page<100?@per_page:100
      @count=Contact.count#@user.contacts.count
      @contacts= Contact.includes([:phone_number]).page(@page).per_page(@per_page).order("first_name asc").all#@user.contacts.includes([:phone_number]).page(@page).per_page(@per_page).order("first_name asc")
      @data={}
      @data[:count]=@count
      @data[:params]={:page=>@page+1 , :per_page=>@per_page}
      @data[:remaining]=((@page*@per_page) < @count) ? true : false
      @data[:empty]=(@count==0 ) ? true : false
      respond_to do |format|
        format.json
        format.js
      end
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
    end

  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
      format.js
    end
  end

  def new
    @contact = Contact.new
    @contact.phone_number=PhoneNumber.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
      format.js
    end
  end


  # POST /create
  # POST /create.json
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      @contact.phone_number.entity=@contact
      @contact.user=current_user
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.js { render action: "new", status: :unprocessable_entity  }
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
      format.js
    end
  end

  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:top_up])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    if @contact.user && current_user
      @contact.delete
      respond_to do |format|
        format.html { redirect_to(people_user_url(current_user)) }
        format.js   { render :nothing => true }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

end
