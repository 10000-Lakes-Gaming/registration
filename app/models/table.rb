class Table < ActiveRecord::Base
  belongs_to :session
  belongs_to :scenario
end
