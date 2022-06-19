class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :media, dependent: :destroy
  has_many :practices, dependent: :destroy

  has_many :friendships_as_requestor, class_name: "Friendship", foreign_key: "requestor_id", dependent: :destroy
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: "receiver_id", dependent: :destroy

  has_many :requestors, through: :friendships_as_requestor
  has_many :receivers, through: :friendships_as_receiver

  has_one_attached :avatar

  enum role: {
    banned: 0,
    user: 1,
    moderator: 2,
    admin: 3
  }

  # get friends
  def friendships
    self.friendships_as_requestor.where(accepted: true) + self.friendships_as_receiver.where(accepted: true)
  end

  def friends
    self.friendships.map { |friendship| friendship.requestor_id == self.id ? friendship.receiver : friendship.requestor }
  end

  def following?(user)
    self.friendships_as_requestor.where(receiver_id: user.id, accepted: true).first.present? || self.friendships_as_receiver.where(requestor_id: user.id, accepted: true).first.present?
  end

  def find_friendship(user)
    self.friendships_as_requestor.where(receiver_id: user.id).first || self.friendships_as_receiver.where(requestor_id: user.id).first
  end

  def pending_requests
    self.friendships_as_requestor.where(accepted: false)
  end

  def pending_invitations
    self.friendships_as_receiver.where(accepted: false)
  end

  # overwrite favorites
  def favorites_populated
    res = []
    read_attribute(:favorites).each do |id|
      res << Exercise.find(id)
    end
    res
  end

  def practices_of_the_day(date = Date.today)
    self.practices.where(created_at: date.all_day)
  end

  def practice_time_today
    res = 0
    self.practices_of_the_day.each do |practice|
      practice.practices_exercises.each do |practice|
        res += practice.duration
      end
    end
    Time.at(res).utc.strftime("%H:%M:%S")
  end

  def practice_time_by_category
    res = {}
    self.practices.each do |practice|
      practice.practices_exercises.each do |practiced|
        # group by categories
        practiced.exercise.categories.each do |category|
          res[category.name] ||= 0
          res[category.name] += practiced.duration
        end
      end
    end
    res
  end

  def practice_time_by_day
    res = {}
    self.practices.each do |practice|
      # group by days
      res[practice.created_at.strftime("%Y-%m-%d")] ||= 0
      practice.practices_exercises.each do |practiced|
        res[practice.created_at.strftime("%Y-%m-%d")] += practiced.duration
      end
    end
    res
  end
end
