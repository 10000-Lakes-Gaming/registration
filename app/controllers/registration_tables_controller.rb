class RegistrationTablesController < ApplicationController
  before_action :set_registration_table, only: [:show, :edit, :update, :destroy]

  # GET /registration_tables
  # GET /registration_tables.json
  def index
    @registration_tables = RegistrationTable.all
  end

  # GET /registration_tables/1
  # GET /registration_tables/1.json
  def show
  end

  # GET /registration_tables/new
  def new
    @registration_table = RegistrationTable.new
  end

  # GET /registration_tables/1/edit
  def edit
  end

  # POST /registration_tables
  # POST /registration_tables.json
  def create
    @registration_table = RegistrationTable.new(registration_table_params)

    respond_to do |format|
      if @registration_table.save
        format.html { redirect_to @registration_table, notice: 'Registration table was successfully created.' }
        format.json { render :show, status: :created, location: @registration_table }
      else
        format.html { render :new }
        format.json { render json: @registration_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registration_tables/1
  # PATCH/PUT /registration_tables/1.json
  def update
    respond_to do |format|
      if @registration_table.update(registration_table_params)
        format.html { redirect_to @registration_table, notice: 'Registration table was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration_table }
      else
        format.html { render :edit }
        format.json { render json: @registration_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_tables/1
  # DELETE /registration_tables/1.json
  def destroy
    @registration_table.destroy
    respond_to do |format|
      format.html { redirect_to registration_tables_url, notice: 'Registration table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration_table
      @registration_table = RegistrationTable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_table_params
      params.require(:registration_table).permit(:table_id, :user_event_id)
    end
end
