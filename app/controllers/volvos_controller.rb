# frozen_string_literal: true

class VolvosController < ApplicationController
  before_action :set_volvo, only: [:show, :edit, :update, :destroy]

  # GET /volvos
  # GET /volvos.json
  def index
    @volvos = Volvo.all
  end

  # GET /volvos/1
  # GET /volvos/1.json
  def show
  end

  # GET /volvos/new
  def new
    @volvo = Volvo.new
  end

  # GET /volvos/1/edit
  def edit
  end

  # POST /volvos
  # POST /volvos.json
  def create
    @volvo = Volvo.new(volvo_params)

    respond_to do |format|
      if @volvo.save
        format.html { redirect_to @volvo, notice: 'Volvo was successfully created.' }
        format.json { render :show, status: :created, location: @volvo }
      else
        format.html { render :new }
        format.json { render json: @volvo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volvos/1
  # PATCH/PUT /volvos/1.json
  def update
    respond_to do |format|
      if @volvo.update(volvo_params)
        format.html { redirect_to @volvo, notice: 'Volvo was successfully updated.' }
        format.json { render :show, status: :ok, location: @volvo }
      else
        format.html { render :edit }
        format.json { render json: @volvo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volvos/1
  # DELETE /volvos/1.json
  def destroy
    @volvo.destroy
    respond_to do |format|
      format.html { redirect_to volvos_url, notice: 'Volvo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_volvo
    @volvo = Volvo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def volvo_params
    params.require(:volvo).permit(:vehicle_id, :position, :registration_number, :vin)
  end
end
