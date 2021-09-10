class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_many :comments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :sessions_of_the_days, dependent: :destroy

  # toto goal

  # overwrite favorites
  def favorites_populated
    res = [] 
    read_attribute(:favorites).each do |id|
      res << Exercise.find(id)
    end
    res
  end


  def sessions_of_today
    res = []
    self.sessions_of_the_days.each do |sessions_of_the_day|
      res << sessions_of_the_day if sessions_of_the_day.created_at >= Time.zone.now.beginning_of_day
    end
    return res && res.count > 0 ? res[0].sessions : nil
  end
end
