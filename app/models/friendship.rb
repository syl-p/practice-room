class Friendship < ActiveRecord::Base
  belongs_to :requestor, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :requestor_id, presence: true
  validates :receiver_id, presence: true

  def self.find_friendship_by_user_id(user_id, friend_id)
    Friendship.where("(requestor_id = ? AND receiver_id = ?) OR (requestor_id = ? AND receiver_id = ?)", user_id, friend_id, friend_id, user_id).first
  end

  def accept!
    self.accepted = true
    self.save
  end

  def reject!
    self.rejected = true
    self.save
  end

  def self.find_friendship(user_id, friend_id)
    Friendship.find_by(requestor_id: user_id, receiver_id: friend_id) || Friendship.find_by(receiver_id: user_id, requestor_id: friend_id)
  end
end
