class Practice < ActiveRecord::Base
  belongs_to :user
  has_many :practices_exercises, dependent: :destroy
end
