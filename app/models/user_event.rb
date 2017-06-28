class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
  has_many :game_masters
  validates :event_id, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true, :uniqueness => {:scope => :event_id}
  validates :payment_id, :presence => true, :if => :payment_amount
  delegate :name, to: :event

  def <=> (other)
    self.user <=> other.user
  end

  def payment_ok?
    # @registration.event.price&.nonzero?
    self.paid? || self.event.price.nil? || self.event.price <= 0
  end

  def gamemaster?
    !game_masters.empty?
  end

  def current_gming_count
    game_masters.length
  end
end
