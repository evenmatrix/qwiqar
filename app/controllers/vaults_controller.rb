class VaultsController < ApplicationController
  # GET /vaults
  # GET /vaults.json
  def index
    @vaults = Vault.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vaults }
    end
  end

  # GET /vaults/1
  # GET /vaults/1.json
  def show
    @vault = Vault.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vault }
    end
  end

  # GET /vaults/new
  # GET /vaults/new.json
  def new
    @vault = Vault.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vault }
    end
  end

  # GET /vaults/1/edit
  def edit
    @vault = Vault.find(params[:id])
  end

  # POST /vaults
  # POST /vaults.json
  def create
    @vault = Vault.new(params[:vault])

    respond_to do |format|
      if @vault.save
        format.html { redirect_to @vault, notice: 'Vault was successfully created.' }
        format.json { render json: @vault, status: :created, location: @vault }
      else
        format.html { render action: "new" }
        format.json { render json: @vault.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vaults/1
  # PUT /vaults/1.json
  def update
    @vault = Vault.find(params[:id])

    respond_to do |format|
      if @vault.update_attributes(params[:vault])
        format.html { redirect_to @vault, notice: 'Vault was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vault.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vaults/1
  # DELETE /vaults/1.json
  def destroy
    @vault = Vault.find(params[:id])
    @vault.destroy

    respond_to do |format|
      format.html { redirect_to vaults_url }
      format.json { head :no_content }
    end
  end
end
