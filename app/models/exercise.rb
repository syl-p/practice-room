class Exercise < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :media_exercises, dependent: :destroy
  has_many :versions, dependent: :destroy
  has_many :media, through: :media_exercises
  belongs_to :user

  accepts_nested_attributes_for :versions, update_only: true

  def self.filtered(query_params)
    if query_params[:text]
      self.where("title ILIKE :text OR body ILIKE :text", text: "%#{query_params[:text]}%")
    else
        self.all
    end
  end

  	
  def versions_attributes=(version_attributes)
    version_attributes.values.each do |version_attribute| 
      version = Version.find(version_attribute["id"])
      version.published = version_attribute['published']
      version.save
    end	  
  end
end