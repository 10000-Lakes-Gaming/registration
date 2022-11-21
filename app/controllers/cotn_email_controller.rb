# frozen_string_literal: true

class CotnEmailController < ApplicationController
  before_action :set_users
  before_action :set_event

  def new
    @message = Message.new
    @message.event = @event
    @message.subject = "Call for Volunteers for #{@event.name}"
  end

  def create
    return unless restrict_to_admin

    @message = Message.new(message_params)
    @message.event = @event

    # defense, for a single real test
    puts "Email list: #{@message.email_list}"
    @message.email_list.reject(&:empty?).each do |email|
      user = User.where(email:).first
      if user.opt_out?
        puts "Not emailing #{user.formal_name} as they have opted out of emails."
      else
        @message.user = @user
        @message.email = email
        puts "Sending to #{user.formal_name} with email #{email}"
        puts "Another check.... #{user.email}"
        AdminMailer.cotn_gm_request_email(@message).deliver
      end
    end

    redirect_to welcome_index_path, notice: 'Your messages has been sent.'
  end

  private

  def set_users
    @users = User.where(opt_out: false).sort
  end

  def set_event
    # This is specific to CotN 2023
    # TODO: Make this a param, so that we can just reuse.
    @event = Event.find(20)
  end

  def message_params
    params.require(:message).permit!
  end
end
