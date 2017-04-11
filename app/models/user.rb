class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_events
  validates_uniqueness_of :email, :pfs_number
  validates :name, :pfs_number, :email, :presence => true

  def long_name
    "#{self.name} (#{self.email})"
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
