class Event < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :user_events, dependent: :destroy
end
