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

  def self.filtered(query_params)
    if query_params.present?
      self.where("title ILIKE :text OR body ILIKE :text", text: "%#{query_params[:text]}%")
    else
      self.all.order("created_at DESC")
    end
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
end
