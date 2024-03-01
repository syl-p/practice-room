class Exercise < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy

  # todo: convert into has_and_belongs_to_many
  has_many :media_exercises, dependent: :destroy
  has_many :media, through: :media_exercises

  has_and_belongs_to_many :categories
  belongs_to :user

  belongs_to :goal_label, optional: true
  has_many :goal_settings, dependent: :destroy

  # accepts_nested_attributes_for :versions, update_only: true

  belongs_to :original, class_name: 'Exercise', optional: true, foreign_key: :exercise_id
  has_many :versions, class_name: 'Exercise', dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }

  enum level: {
    beginner: 0,
    intermediate: 1,
    advanced: 2
  }

  # private, public, restricted
  enum visibility: {
    everyone: 0,
    not_referenced: 1, # by url only
    restricted: 2, # TODO: filter by user list
  }

  before_destroy :remove_from_favorites
  before_save :generate_slug

  def self.for_current_user(user = nil)
    if user.present?
      exercices = self.where("user_id = ? OR (published = true AND visibility = 0)", user&.id)
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

  def goal_setting_for_current_user(user = nil)
    return unless user_id.present?
    goal_settings.find_by(user_id: user&.id)
  end

  private
  def remove_from_favorites
    User.all.each do |user|
      user.update(favorites: user.favorites.reject { |f| f == self.id.to_s })
    end
  end

  def generate_slug
    self.slug = title.parameterize
  end
end
