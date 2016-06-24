class Event < ActiveRecord::Base
  has_many :sessions
  has_many :user_events
end
