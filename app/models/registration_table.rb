class RegistrationTable < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :table

end
