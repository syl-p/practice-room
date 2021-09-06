class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: "Comment"
  has_many :comments, foreign_key: :parent_id, dependent: :destroy


  validates :body, presence: true

  after_create_commit do 
    # broadcast_append_to [commentable, :comments], target: "#{dom_id(parent || commentable)}_comments"
  end

  after_destroy_commit do
    # broadcast_remove_to self
  end
end
