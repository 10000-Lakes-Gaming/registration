class GameMaster < ActiveRecord::Base
  belongs_to :table
  belongs_to :user_event
  validates :table_id, :presence => true, :uniqueness => {:scope => :user_event_id}
  validates :user_event_id, :presence => true, :uniqueness => {:scope => :table_id}
  validate :check_gm_count

  def check_gm_count
    errors.add :game_masters, "Max GMs Exceeded" if table.game_masters.count > table.gms_needed
  end

end
