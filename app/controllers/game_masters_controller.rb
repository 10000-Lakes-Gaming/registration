# frozen_string_literal: true

class GameMastersController < ApplicationController
  include ApplicationHelper

  before_action :set_game_master, only: %i[show edit update destroy]
  before_action :get_event, :get_session, :get_table, :get_user_event, :get_possible_gms
  # GET /game_masters/1
  # GET /game_masters/1.json
  def show; end

  # GET /game_masters/new
  def new
    @game_master = GameMaster.new
  end

  def get_possible_gms
    @possible_gms = []
    @not_available = []

    @event.user_events.each do |user_event|
      in_session = false
      user_event.registration_tables.each do |reg_table|
        in_session ||= reg_table.table.session == @session
      end
      user_event.game_masters.each do |game_master|
        in_session ||= game_master.table.session == @session
      end

      if in_session
        @not_available.push user_event
      else
        @possible_gms.push user_event
      end
      # need to sort the gms
      # @tables = @session.tables.sort {|a,b| a <=> b}
      @possible_gms = @possible_gms.sort { |a, b| a <=> b }
    end
  end

  def get_table
    @table = Table.find(params[:table_id])
  end

  def get_session
    @session = @event.sessions.find(params[:session_id])
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_user_event
    @user_event = UserEvent.find_by_event_id_and_user_id(params[:event_id], current_user.id)
  end

  # GET /game_masters
  # GET /game_masters.json
  def index
    restrict_to_hosts
    @game_masters = GameMaster.where(table_id: @table.id)
  end

  # GET /game_masters/1/edit
  def edit
    restrict_to_gamemaster
    @possible_gms << @game_master.user_event
  end

  # POST /game_masters
  # POST /game_masters.json
  # TODO - can only admins add GMs?
  def create
    # TODO: - do something if already registered for table/session
    @game_master = GameMaster.new(game_master_params)
    if current_user.admin?
      @user_event = @game_master.user_event
      user = @user_event.user
    else
      # for the user event to the current user's
      @user_event = get_user_event
      user = @user_event.user
      @game_master.user_event = @user_event
    end
    email = user.email

    respond_to do |format|
      if @game_master.save
        ContactMailer.game_master(get_email_message, email, @event, @game_master, true).deliver

        if current_user.admin?
          format.html { redirect_to [@event, @session, @table], notice: 'Game master was successfully added.' }
        else
          format.html { redirect_to [@event], notice: "You are now a GM for #{@table.long_name}" }
        end
        format.json { render :show, status: :created, location: @game_master }
      else
        format.html { render :new }
        format.json { render json: @game_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_masters/1
  # PATCH/PUT /game_masters/1.json
  def update
    restrict_to_gamemaster
    back_to_session = ActiveModel::Type::Boolean.new.cast(params['session-page'])
    respond_to do |format|
      all_ok = @game_master.update(game_master_params)
      all_ok &&= @game_master.warnings.empty?
      if all_ok
        format.html do
          if back_to_session
            redirect_to [@event, @session], notice: 'Added Game Master Sign Up sheet.'
          else
            redirect_to [@event, @session, @table, @game_master], notice: 'Game master was successfully updated.'
          end
        end
        format.json { render :show, status: :ok, location: [@event, @session, @table, @game_master] }
      else
        format.html {
          if back_to_session
            redirect_to [@event, @session], notice: 'Added Game Master Sign Up sheet.'
          else
            render :edit
          end
        }
        format.json { render json: @game_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_masters/1
  # DELETE /game_masters/1.json
  def destroy
    restrict_to_admin
    @game_master.destroy

    gm_name = '<UNKNOWN>'
    unless @game_master.user_event.nil?
      user_event = @game_master.user_event
      email = user_event.user.email
      gm_name = user_event.user.name
      ContactMailer.game_master(get_email_message, email, @event, @game_master, false).deliver
    end
    respond_to do |format|
      format.html { redirect_to [@event], notice: "#{gm_name} was removed as a Game Master from table." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game_master
    @game_master = GameMaster.find(params[:id])
  end

  def get_email_message
    message = Message.new
    message.subject = "Change in GM assignments for #{@event.name}"
    message
  end

  # Never trust parameters from the scary internet, only allow the allowlist through.
  def game_master_params
    params.require(:game_master).permit(:table_id, :user_event_id, :table_number, :vtt_type, :vtt_name, :vtt_url,
                                        :sign_in_url)
  end
end
