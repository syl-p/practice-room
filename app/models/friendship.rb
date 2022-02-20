class Friendship < ActiveRecord::Base
  belongs_to :requestor, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :requestor_id, presence: true
  validates :receiver_id, presence: true
end
