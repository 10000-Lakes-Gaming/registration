class UserEvent < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_events
  belongs_to :event, inverse_of: :user_events
  has_many :registration_tables
  has_many :game_masters
  has_many :additional_payments
  validates :event_id, :presence => true, :uniqueness => { :scope => :user_id }
  validates :user_id, :presence => true, :uniqueness => { :scope => :event_id }
  validates :payment_id, :presence => true, :if => :payment_amount
  delegate :name, to: :event

  def <=> (other)
    self.user <=> other.user
  end

  def formatted_payment_date
    self.payment_date&.strftime(Session::DATETIME_FORMAT)
  end

  def sessions
    all_tickets_by_session.keys.sort
  end

  def all_tickets_by_session
    return @tickets_by_session unless @tickets_by_session.nil?

    @tickets_by_session = {}
    registration_tables.each do |ticket|
      @tickets_by_session[ticket.table.session] = ticket
    end
    game_masters.each do |gm|
      @tickets_by_session[gm.table.session] = gm
    end
    @tickets_by_session
  end

  def all_tables
    tables = []
    registration_tables.each do |reg_table|
      tables << reg_table.table
    end
    game_masters.each do |gm|
      tables << gm.table
    end
    tables.sort { |a, b| a.session <=> b.session }
  end

  def payment_ok?
    # @registration.event.price&.nonzero?
    self.paid? || self.registration_cost.nil? || self.registration_cost <= 0
  end

  def gamemaster?
    !game_masters.empty?
  end

  def current_gming_count
    game_masters.length
  end

  def unique_scenarios
    game_masters.map { |gm| gm.table.scenario }.uniq

  end

  def unpaid_additional_payments?
    additional_payments.any? { |payment| payment.payment_id.nil? }
  end

  def registration_cost
    donation || event.price
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
    self.additional_payments.any? { |payment| payment.charitable_donation? }
  end

  def past
    Time.now > self.event.end
  end

  def no_signups?
    self.registration_tables.empty?
  end

  def self.to_csv
    attributes = %w{event event_id player_formal player_name pfs_number registration_number}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |ticket|
        csv << [ticket.event.name, ticket.event.id, ticket.user.formal_name, ticket.user.name, ticket.user.pfs_number, ticket.id]
      end
    end
  end
end
