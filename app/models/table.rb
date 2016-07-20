class Table < ActiveRecord::Base
  belongs_to :session
  belongs_to :scenario
  has_many :registration_tables
  delegate :name, to: :session
  delegate :start, to: :session
end
