class Exercise < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :media_exercises, dependent: :destroy
  has_many :versions, dependent: :destroy
  has_many :media, through: :media_exercises
  belongs_to :user

  def self.filtered(query_params)
    if query_params[:text]
      self.where("title ILIKE :text OR body ILIKE :text", text: "%#{query_params[:text]}%")
    else
        self.all
    end
  end
end