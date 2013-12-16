class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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

  def confirm
    @order = Order.find(params[:id])
    if @order && current_user=@order.user
      @order.confirm
      respond_to do |format|
        format.html { redirect_to user_root_url}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to user_root_url, alert: 'Unauthorized' }
        format.json {render :json => {:error=>"not found"},:status => 404}
      end
    end
  end


  def destroy
    @order = Order.find(params[:id])
    if @order && @order.user==current_user
      if @order.pending?
        @order.cancel
        @order.destroy
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

end
