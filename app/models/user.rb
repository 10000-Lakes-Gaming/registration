class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_events
  has_many :event_hosts
  validates_uniqueness_of :email, :pfs_number
  validates :name, :email, :presence => true
  validates :title, :presence => true, if: :venture_officer?
  validate :pfs_or_dci_number_exists

  def pfs_or_dci_number_exists
    if pfs_number.nil? && dci_number.nil?
      errors.add(:base, 'You must enter either a Paizo Organized Play number or a DCI Number')
    end
  end

  def org_play_number
    if pfs_number.blank?
      "DCI# #{dci_number}"
    else
      "#{pfs_number}"
    end
  end

  def long_name
    "#{self.name} (#{self.email})"
  end

  def formal_name
    "#{self.title} #{self.name}"
  end

  def formal_name_with_stars
    "#{self.title} #{self.name} #{self.show_stars}"
  end

  STAR = "\u272f"

  def show_stars
    star = STAR
    star = star.encode('utf-8')
    stars = ""
    (1..self.gm_stars.to_i).each do
      stars = "#{stars}#{star}"
    end
    stars
  end

  def current_events
    current_events = []
    user_events.each do |reg|
      if reg.event.end > Time.now
        current_events << reg
      end
    end
    current_events
  end

  def <=> (user)
    sort = 0
    if user.nil?
      sort = -1
    else
      sort = self.name <=> user.name
    end
    sort
  end


end
