class WalletsController < ApplicationController
  # GET /wallets
  # GET /wallets.json
  def index
    @wallets = Wallet.all
    respond_to do |format|
      format.html # wallet.html.erb
      format.json { render json: @wallets }
    end
  end

  def deposit
    @user=User.find(params[:user_id])
    @deposit = Order.new(params[:order])
    if(current_user=@user)
      @deposit.user=@user
      @deposit.item.itemable=@user.wallet
      @deposit.user=@user
      if(@deposit.valid?)
        @deposit.save
        @order=new_order
      else
        respond_to do |format|
          format.html { render action: "show" }
          format.json { render json: @wallet.errors, status: :unprocessable_entity }
          format.js
        end
      end
     else
      respond_to do |format|
        format.html { redirect_to user_root_url, alert: 'Unauthorized' }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def confirm_order
    @user=User.find(params[:user_id])
    if(current_user=@user)
      @deposit.user=@user
      @deposit.item.itemable=@user.wallet
      @deposit.user=@user
      if(@deposit.save!)
        @order=new_order
      else
        respond_to do |format|
          format.html { render action: "show" }
          format.json { render json: @wallet.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to user_root_url, alert: 'Unauthorized' }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end
  # GET /wallets/1
  # GET /wallets/1.json
  def show
    @wallet = Wallet.find(params[:id])
    @deposit=new_order
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wallet }
    end
  end

  # GET /wallets/new
  # GET /wallets/new.json
  def new
    @wallet = Wallet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wallet }
    end
  end

  # GET /wallets/1/edit
  def edit
    @wallet = Wallet.find(params[:id])
  end

  # POST /wallets
  # POST /wallets.json
  def create
    @wallet = Wallet.new(params[:wallet])

    respond_to do |format|
      if @wallet.save
        format.html { redirect_to @wallet, notice: 'Wallet was successfully created.' }
        format.json { render json: @wallet, status: :created, location: @wallet }
      else
        format.html { render action: "new" }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wallets/1
  # PUT /wallets/1.json
  def update
    @wallet = Wallet.find(params[:id])

    respond_to do |format|
      if @wallet.update_attributes(params[:wallet])
        format.html { redirect_to @wallet, notice: 'Wallet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /wallets/1
  # DELETE /wallets/1.json
  def destroy
    @wallet = Wallet.find(params[:id])
    @wallet.destroy

    respond_to do |format|
      format.html { redirect_to wallets_url }
      format.json { head :no_content }
    end
  end

  private


  def new_order
    order=Order.new
    order.item=Item.new
    order.item.itemable=current_user.wallet
    order.payment_processor=PaymentProcessor.new
    order
  end

end
