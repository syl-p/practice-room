class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :sessions_of_the_days, dependent: :destroy

  has_many :friendships_as_requestor, class_name: "Friendship", foreign_key: "requestor_id", dependent: :destroy
  has_many :friendships_as_receiver, class_name: "Friendship", foreign_key: "receiver_id", dependent: :destroy

  has_many :requestors, through: :friendships_as_requestor
  has_many :receivers, through: :friendships_as_receiver

  include AvatarUploader::Attachment(:avatar)

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

  def sessions_of_today
    return self.sessions_of_the_days.where(created_at: Time.current.all_day).first
  end
end
