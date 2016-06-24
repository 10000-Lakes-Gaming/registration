class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
end
