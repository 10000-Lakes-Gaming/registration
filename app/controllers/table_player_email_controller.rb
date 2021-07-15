# frozen_string_literal: true

class TablePlayerEmailController < ApplicationController
  before_action :set_table

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    session = @table.session
    event = session.event

    if @message.valid?
      ContactMailer.email_players(@message, @table, current_user).deliver
      redirect_to event_session_table_path(event, session, @table), notice: 'Your messages has been sent.'
    else
      flash[:alert] = 'An error occurred while delivering this message.'
      render :new
    end
  end

  private

  def set_table
    @table = Table.find(params[:table_id])
  end

  def message_params
    params.require(:message).permit(:name, :email, :content, :subject, :table_id)
  end
end
