class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_many :comments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :sessions_of_the_days, dependent: :destroy

  # overwrite favorites
  def favorites_populated
    res = [] 
    read_attribute(:favorites).each do |id|
      res << Exercise.find(id)
    end
    res
  end

  def sessions_of_today
    return self.sessions_of_the_days.where(created_at: Time.current.all_day).first
  end
end
