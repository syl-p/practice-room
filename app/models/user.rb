class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :media, dependent: :destroy
  has_many :practices, dependent: :destroy

  # follows relation
  has_many :follows_as_following, class_name: "Follow", foreign_key: "follower_id"
  has_many :following, through: :follows_as_following

  has_many :follows_as_follower, class_name: "Follow", foreign_key: "following_id"
  has_many :followers, through: :follows_as_follower

  has_one_attached :avatar

  enum role: {
    banned: 0,
    user: 1,
    moderator: 2,
    admin: 3
  }

  # overwrite favorites
  def favorites_populated
    Exercise.where(id: read_attribute(:favorites))
  end

  # pratices methods
  def practices_of_the_day(date = Date.today)
    self.practices.where(created_at: date.all_day)
  end

  def practices_of_the_week(date = Date.today)
    self.practices.where(created_at: date.beginning_of_week..date.end_of_week)
  end

  def practice_time_today
    res = 0
    self.practices_of_the_day.each do |practice|
      practice.practices_exercises.each do |practice|
        res += practice.duration
      end
    end
    res
  end

  def practice_time_by_category
    res = {}
    self.practices.each do |practice|
      practice.practices_exercises.each do |practiced|
        # group by categories
        practiced.exercise.categories.each do |category|
          res[category.name] ||= 0
          res[category.name] += practiced.duration
        end
      end
    end
    res
  end

  def practice_time_this_week
    res = {}
    self.practices.where('created_at >= ?', 1.week.ago).each do |practice|
      # group by days
      res[practice.created_at.strftime("%Y-%m-%d")] ||= 0
      practice.practices_exercises.each do |practiced|
        res[practice.created_at.strftime("%Y-%m-%d")] += practiced.duration
      end
    end
    res
  end

  def top_exercises_list
    PracticesExercise.joins(:practice).joins(exercise: :user).where(practices: {user_id: self.id})
                     .group('title', 'exercise_id', 'username', 'exercises.user_id')
                     .order('COUNT(practices_exercises.exercise_id) DESC')
                     .count(:exercise_id)

  end
end
