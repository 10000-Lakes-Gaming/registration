class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_events
  validates_uniqueness_of :email, :pfs_number
  validates :name, :pfs_number, :email, :presence => true
  validates :title, :presence => true, if: :venture_officer?

  def long_name
    "#{self.name} (#{self.email})".strip!
  end

  def formal_name
    "#{self.title} #{self.name}".strip!
  end
  def formal_name_with_stars
    "#{self.title} #{self.name} #{self.show_stars}".strip!
  end

  STAR = "\u272F"

  def show_stars
    star  = STAR
    star  = star.encode('utf-8')
    stars = ""
    (1..self.gm_stars.to_i).each do
      stars = "#{stars}#{star}"
    end
    stars.strip!
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
