class Exercise < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :versions, dependent: :destroy

  # todo: convert into has_and_belongs_to_many
  has_many :media_exercises, dependent: :destroy
  has_many :media, through: :media_exercises

  has_and_belongs_to_many :categories
  belongs_to :user

  accepts_nested_attributes_for :versions, update_only: true

  belongs_to :original, class_name: 'Exercise', optional: true, foreign_key: :exercise_id
  has_many :versions, class_name: 'Exercise', dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }

  enum level: {
    beginner: 0,
    intermediate: 1,
    advanced: 2
  }

  enum visibility: {
    everyone: 0,
    not_referenced: 1, # by url only
    friends: 2 # access by friends only
  }

  before_destroy :remove_from_favorites

  def self.filtered(query_params)
    if query_params.present?
      self.where("title ILIKE :text OR body ILIKE :text", text: "%#{query_params[:text]}%")
    else
      self.all.order("created_at DESC")
    end
  end

  def self.for_current_user(user_id = nil)
    if user_id
      # own exercises + (exercise visibility = 0 or (visibility = 2 and friends))
      exercices = self.where("user_id = ? OR (published = true AND (visibility = 0 OR (visibility = 2 AND user_id IN (?))))", user_id, user_id.friends)
    else
      exercices = self.where({published: true, visibility: 0, original: nil})
    end
    exercices.where(original: nil).order("created_at DESC")
  end

  def versions_filtered(user_id = nil)
    if user_id
      if user === user_id
        versions
      else
        versions.where("published = true OR user_id = ?", user_id).order("created_at ASC")
      end
    else
      versions.where({published: true}).order("created_at ASC")
    end
  end

  def remove_from_favorites
    User.all.each do |user|
      user.update(favorites: user.favorites.reject { |f| f == self.id.to_s })
    end
  end
end
