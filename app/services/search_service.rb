class SearchService
  def call(query, current_user)
    @query = query
    @current_user = current_user
    default_results.tap do |results|
      next if @query.blank?
      results[:exercises] = perform_exercises_search!
      results[:users] = perform_users_search!
      results[:categories] = perform_categories_search!
    end
  end

  def default_results
    { exercises: [], users: [], categories: [] }
  end

  def perform_exercises_search!
    Exercise.for_current_user(@current_user).where("title ILIKE :text OR body ILIKE :text", text: "%#{@query}%").limit(5)
  end

  def perform_users_search!
    User.where("username ILIKE :text", text: "%#{@query}%").limit(3)
  end

  def perform_categories_search!
    Category.where("name ILIKE :text", text: "%#{@query}%").limit(5)
  end
end
