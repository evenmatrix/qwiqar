include InterswitchHelper
include TopUpGenieHelper
include WalletsHelper
class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      if current_user == @user
        @page=(params[:page]||1).to_i
        @per_page  = (params[:per_page] || 10).to_i
        @search = current_user.orders.search(params[:q])
        @count=@search.result.count
        @orders = @search.result.page(@page).per_page(@per_page).order("created_at desc")
      else
        respond_to do |format|
          format.html {redirect_to root_url, alert: "Access Denied"}
        end
      end
    end
  end

  def search
    query=params[:q]
    Orders.where
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  def cancel
    @order = Order.find(params[:id])
    if @order && current_user=@order.user
      @order.cancel
      respond_to do |format|
        format.html { redirect_to user_root_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to user_root_url, alert: 'Unauthorized' }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end

  def check_status
    @order = Order.find(params[:id])
    if @order && current_user=@order.user
      if @order.pending?
        case @order.payment_processor.name
                  when "interswitch"
                    query_order_status(@order)
        end
      end
      if @order.payed?
        query_order_delivery_status(@order)
      end
      render "show"
    else
      format.html { redirect_to user_orders_path(current_user) }
      format.json { head :no_content }
      format.js
    end
  end

  def pay
    @order = Order.find_by_transaction_id(params[:transaction_id])
    if(@order && @order.user==current_user)
      if verify_mac(params)
        Order.transaction do
          begin
            if @order.pending?  || @order.failed?
              @wallet=current_user.wallet
              if @wallet.balance >= @order.total_amount
                @wallet.debit_wallet(@order.total_amount)
                @order.response_code="W00"
                @order.response_description=WALLET_RESPONSE_CODE_TO_DESCRIPTION[@order.response_code]
                @order.payed
                render "show"
              else
                @order.response_code="W02"
                @order.response_description=WALLET_RESPONSE_CODE_TO_DESCRIPTION[@order.response_code]
                logger.info "response_description: #{@order.response_description}"
                @order.save
                @order.failed
                render "show"
              end
            else
              render "show"
            end
          rescue Exception => e
            logger.info "ERROR #{e.message}"
              @_errors = true
            render "show"
          end
          raise ActiveRecord::Rollback if @_errors
        end
      else
        @order.response_code="W03"
        @order.response_description=WALLET_RESPONSE_CODE_TO_DESCRIPTION[@order.response_code]
        @order.failure
        logger.info "mac verification failed"
        format.html { redirect_to user_orders_path(current_user) }
        format.json { head :no_content }
        format.js
      end
    else
      format.html { redirect_to user_orders_path(current_user) }
      format.json { head :no_content }
      format.js
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order && @order.user==current_user
      if @order.pending?
        @order.cancel
        respond_to do |format|
          format.html { redirect_to user_orders_path(current_user) }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to @order, alert: "This order cannot be canceled" }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @order, alert: "Unauthorized" }
        format.json { head :no_content }
      end
    end
  end

  private

  def query_order_delivery_status(order)
    unless order.item.delivered?
      order.item.deliver order
    end
  end

end
