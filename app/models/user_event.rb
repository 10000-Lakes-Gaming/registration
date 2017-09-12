class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :registration_tables
  has_many :game_masters
  has_many :additional_payments
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

  def unpaid_additional_payments?
    additional_payments.any? {|payment| payment.payment_id.nil?}
  end

  def total_paid
    total = self.payment_amount.to_i
    registration_tables.each do |table|
      total += table.payment_amount.to_i
    end
    additional_payments.each do |payment|
      total += payment.payment_amount.to_i
    end
    # put in dollars
    total.to_i / 100
  end

  def total_price
    total = self.event.price.to_i
    registration_tables.each do |table|
      total += table.price.to_i
    end
    additional_payments.each do |payment|
      total += payment.price.to_i
    end
    total
  end

  def has_charitable_donation?
    self.additional_payments.any? {|payment| payment.donation?}
  end

  def past
    Time.now > self.event.end
  end

  def no_signups?
    self.registration_tables.empty?
  end

end
