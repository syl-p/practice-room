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


  def sessions_of_the_day
    read_attribute(:sessions_of_the_days).select {|v| => v.date === Date.today}
  end
end
