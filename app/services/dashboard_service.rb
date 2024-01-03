class DashboardService
  def initialize(current_user)
    @current_user = current_user
  end

  # return [bool, current_value, goal_value]
  def more_than_10_mn_today?
    practice_time = @current_user.practice_time_today
    return [practice_time >= 20.minutes, practice_time, 20.minutes]
  end

  def have_3_exercises_today?
    count = @current_user.practices_of_the_day.joins(:practices_exercises).count(:practices_exercises)
    return [count >= 3, count, 3]
  end

  def each_categories_today?
    return [false, 0, 3]
  end
end
