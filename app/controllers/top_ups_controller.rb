class TopUpsController < ApplicationController
  # GET /top_ups
  # GET /top_ups.json
  def index
    @top_ups = TopUp.all

    respond_to do |format|
      format.html # index.html.erb
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

  # GET /top_ups/new
  # GET /top_ups/new.json
  def new
    @top_up = TopUp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @top_up }
    end
  end

  # GET /top_ups/1/edit
  def edit
    @top_up = TopUp.find(params[:id])
  end

  # POST /top_ups
  # POST /top_ups.json
  def create
    @top_up = TopUp.new(params[:top_up])

    respond_to do |format|
      if @top_up.save
        format.html { redirect_to @top_up, notice: 'Top up was successfully created.' }
        format.json { render json: @top_up, status: :created, location: @top_up }
      else
        format.html { render action: "new" }
        format.json { render json: @top_up.errors, status: :unprocessable_entity }
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
end
