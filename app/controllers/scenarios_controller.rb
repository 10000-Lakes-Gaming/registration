# frozen_string_literal: true

class ScenariosController < ApplicationController
  helper ApplicationHelper
  before_action :set_scenario, only: %i[show edit update destroy clone]

  def prevent_non_admin
    redirect_to scenarios_path unless current_user.admin?
  end

  # GET /scenarios
  # GET /scenarios.json
  def index
    @scenarios = Scenario.all.to_a.sort

    respond_to do |format|
      format.html do
        render :index
      end
      format.json do
        render :index
      end
      format.csv do
        send_data Scenario.to_csv(@scenarios), filename: 'all_scenarios.csv'
      end
    end
  end

  # POST /scenarios/upload_scenarios
  def load_from_csv
    prevent_non_admin

    @csv_errors = Scenario.import(params[:file])
    @scenarios = Scenario.all.to_a.sort

    render :index
  end

  def clone
    prevent_non_admin
    @scenario = @scenario.copy
    render :new
  end

  # GET /scenarios/1
  # GET /scenarios/1.json
  def show; end

  # GET /scenarios/new
  def new
    prevent_non_admin
    @scenario = Scenario.new
  end

  # GET /scenarios/1/edit
  def edit
    prevent_non_admin
  end

  # POST /scenarios
  # POST /scenarios.json
  def create
    prevent_non_admin
    @scenario = Scenario.new(scenario_params)

    respond_to do |format|
      if @scenario.save
        format.html { redirect_to @scenario, notice: 'Scenario was successfully created.' }
        format.json { render :show, status: :created, location: @scenario }
      else
        format.html { render :new }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scenarios/1
  # PATCH/PUT /scenarios/1.json
  def update
    prevent_non_admin
    respond_to do |format|
      if @scenario.update(scenario_params)
        format.html { redirect_to @scenario, notice: 'Scenario was successfully updated.' }
        format.json { render :show, status: :ok, location: @scenario }
      else
        format.html { render :edit }
        format.json { render json: @scenario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scenarios/1
  # DELETE /scenarios/1.json
  def destroy
    prevent_non_admin
    @scenario.destroy
    respond_to do |format|
      format.html { redirect_to scenarios_url, notice: 'Scenario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scenario
    scenario_id = params[:id] || params[:scenario_id]
    @scenario = Scenario.find(scenario_id)
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def scenario_params
    params.require(:scenario).permit(:game_system, :type_of, :season, :scenario_number, :name, :description, :author,
                                     :paizo_url, :hard_mode, :pregen_only, :tier, :retired, :evergreen, :catalog_number)
  end
end
