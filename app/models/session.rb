class Session < ActiveRecord::Base
  belongs_to :event
  has_many :tables
end
