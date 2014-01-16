include TopUpGenieHelper
class TopUpsController < ApplicationController
  # GET /top_ups
  # GET /top_ups.json
  def index
    @top_ups = TopUp.all
    respond_to do |format|
      format.html # wallet.html.erb
      format.json { render json: @top_ups }
    end
  end

  # GET /top_ups/1
  # GET /top_ups/1.json
  def show
    @top_up = TopUp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @top_up }
    end
  end

  def contact
    @user = User.find(params[:user_id])
    @contact = Contact.find(params[:contact_id])
    if @user && current_user
      @top_up=ContactTopUp.new
      @top_up.item=Item.new
      @top_up.contact=@contact
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def create_contact
    @user = User.find(params[:user_id])
    @contact = Contact.find(params[:contact][:id])
    if @user && current_user && @contact
      @top_up=ContactTopUp.new params[:contact_top_up]
      @top_up.sender=current_user
      @contact.contact_top_ups << @top_up
      if @top_up.save
        begin
          @order = create_order
          respond_to do |format|
            format.html
            format.js
          end
        rescue Exception=>e
          logger.info "Error:,#{e.message}"
          logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
          respond_to do |format|
            format.html { render action: "contact" }
            format.js { render action: "contact", status: :unprocessable_entity  }
          end
        end
      else
        respond_to do |format|
          format.html { render action: "contact" }
          format.js { render action: "contact", status: :unprocessable_entity  }
        end
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def create_phone_number
    @user = User.find(params[:user_id])
    if @user && current_user
      @phone_number=PhoneNumber.uniq(params[:phone_number][:carrier_id],params[:phone_number][:number])
      @phone_number=PhoneNumber.new params[:phone_number] unless @phone_number
      @top_up=PhoneNumberTopUp.new params[:phone_number_top_up]
      @phone_number.phone_number_top_ups << @top_up
      if @phone_number.save
        begin
          @order = create_order
            respond_to do |format|
            format.html
            format.js
          end
        rescue Exception=>e
          logger.info "Error:,#{e.message}"
          logger.warn $!.backtrace.collect { |b| " > #{b}" }.join("\n")
          respond_to do |format|
            format.html { render action: "phone_number" }
            format.js { render action: "phone_number", status: :unprocessable_entity  }
          end
        end
      else
        respond_to do |format|
        format.html { render action: "phone_number" }
        format.js { render action: "phone_number", status: :unprocessable_entity  }
        end
      end
    else
      respond_to do |format|
        format.html { render action: "phone_number" }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def phone_number
    @user = User.find(params[:user_id])
    if @user && current_user==@user
      @top_up=PhoneNumberTopUp.new
      @top_up.item=Item.new
      @phone_number=PhoneNumber.new
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def new
    @user = User.find(params[:user_id])
    if @user && current_user
      @top_up = TopUp.new
      @top_up.phone_number=PhoneNumber.new
      if params[:topable_id].present? && params[:topable_type].present?
        @top_up.topable=params[:topable_type].constantize.find(params[:topable_id])
      else
        @top_up.topable= @topable
      end
      respond_to do |format|
        format.html
        format.js
        format.json
      end
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  # GET /top_ups/1/edit
  def edit
    @top_up = TopUp.find(params[:id])
  end

  # POST /top_ups
  # POST /top_ups.json
  def create

    @user = User.find(params[:user_id])
    if @user && current_user
      @top_up = TopUp.new(params[:top_up])
      @order = Order.new(params[:order])
      @top_up.sender=current_user
      respond_to do |format|
        if @top_up.save
          format.html { redirect_to @top_up, notice: 'Top up was successfully created.' }
          format.json { render json: @top_up, status: :created, location: @top_up }
        else
          format.html { render action: "new" }
          format.json { render json: @top_up.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  # PUT /top_ups/1
  # PUT /top_ups/1.json
  def update
    @top_up = TopUp.find(params[:id])

    respond_to do |format|
      if @top_up.update_attributes(params[:top_up])
        format.html { redirect_to @top_up, notice: 'Top up was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @top_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /top_ups/1
  # DELETE /top_ups/1.json
  def destroy
    @top_up = TopUp.find(params[:id])
    @top_up.destroy

    respond_to do |format|
      format.html { redirect_to top_ups_url }
      format.json { head :no_content }
    end
  end


  private

  def create_order
    order = Order.new
    order.item=@top_up.item
    order.user=current_user
    order.payment_processor=PaymentProcessor.find @top_up.payment_processor_id
    order.save!
    order
  end
end
