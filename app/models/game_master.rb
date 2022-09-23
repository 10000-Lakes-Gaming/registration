# frozen_string_literal: true

class GameMaster < ActiveRecord::Base
  belongs_to :table
  belongs_to :user_event
  delegate :online, :online?, to: :table
  delegate :start, to: :table
  delegate :end, to: :table
  delegate :scenario, to: :table
  delegate :long_name, to: :table
  validates :table_id, presence: true, uniqueness: { scope: :user_event_id }
  validates :user_event_id, presence: true, uniqueness: { scope: :table_id }
  validate :check_gm_count
  validate :validate_vtt_fields

  attr_accessor :save_despite_warnings

  before_save :check_for_warnings
  before_update :check_for_warnings
  before_create :check_for_warnings

  def scenario_requested?
    scenario_requested.present?
  end

  def requestable_scenario?
    # Must be campaign PFS, PFS2, or SFS, and have a PZO number
    # Also, user must not be VO
    scenario.opf_type? && scenario.catalog_number.present? && user_event.user.venture_officer?
  end

  def warnings
    @warnings ||= ActiveModel::Errors.new(self)
  end

  def check_for_warnings
    # warnings.add(:notes, :too_long, count: 120) if notes.to_s.length > 120
    !!save_despite_warnings
  end

  def validate_vtt_fields
    if online?
      warnings.add(:vtt_type, :required) if vtt_type.blank?
      warnings.add(:vtt_name, :required) if vtt_name.blank?
      warnings.add(:vtt_url, :required) if vtt_url.blank?
      warnings.add(:sign_in_url, :required) if sign_in_url.blank?
    else
      errors[:vtt_type] << 'is not allowed for in-person table' if vtt_type.present?
      errors[:vtt_name] << 'is not allowed for in-person table' if vtt_name.present?
      errors[:vtt_url] << 'is not allowed for in-person table' if vtt_url.present?
    end
  end

  def missing_online_setup?
    vtt_type.blank? || vtt_name.blank? || vtt_url.blank? || sign_in_url.blank?
  end

  def check_gm_count
    # first check to see if this GM is already in the table's game masters.
    if !table.game_masters.include?(self) && (table.game_masters.count >= table.gms_needed)
      errors.add :game_masters, 'Max GMs Exceeded'
    end
  end

  def assigned(user)
    event = table&.session&.event
    registration = user.registration_for_event event
    registration.game_masters.include? self
  end

  def self.to_request_csv(game_masters)
    attributes = ['GM Name', 'Email used on Paizo.com', 'Forum Username', 'Scenario PZO', 'Scenario Name', ' ',
                  'Convention Name']
    CSV.generate(headers: true) do |csv|
      csv << attributes
      game_masters.each do |gm|
        csv << [gm.user_event.user.name,
                gm.user_event.user.email,
                gm.user_event.user.forum_username,
                gm.scenario.catalog_number,
                gm.scenario.long_name,
                '',
                gm.user_event.event.name]
      end
    end
  end

  def self.to_csv(game_masters)
    attributes = %w[event_name session_name session_start session_end scenario gm_name gm_pfs_number gm_email
                    gm_forum_username gm_title table_assignment sign_in_url]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      game_masters.each do |game_master|
        csv << [game_master.user_event.event.name,
                game_master.table.session.name,
                game_master.table.session.start.localtime.to_formatted_s(:long),
                game_master.table.session.end.localtime.to_formatted_s(:long),
                game_master.table.scenario.long_name,
                game_master.user_event.user.name,
                game_master.user_event.user.pfs_number,
                game_master.user_event.user.email,
                game_master.user_event.user.forum_username,
                game_master.user_event.user.title,
                game_master.table_number,
                game_master.sign_in_url]
      end
    end
  end

  def <=>(other)
    # sort by user
    sorted = user_event <=> other.user_event
    if sorted.zero?
      # then scenario number
      sorted = table.scenario <=> other.table.scenario
    end
    sorted
  end
end
