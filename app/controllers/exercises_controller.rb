class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit get_versions_list update destroy add_to_favorites ]
  authorize_resource
  
  # specific layout for manage actions
  layout "layouts/dashboard", only: [:edit, :new, :me]

  # GET /exercises or /exercises.json
  def index
    @exercises = Exercise.filtered(params)
    if params[:export].present?
      render partial: "shared/exercise_list"
    end
  end

  def get_versions_list
    render partial: "versions/list", locals: {versions: @exercise.versions, exercise: @exercise}
  end

  def me
    @exercises = current_user.exercises
    render :me
  end

  # GET /exercises/1 or /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new
  end

  # GET /exercises/1/edit
  def edit
    if params[:step].present?
      case params[:step]
      when "media"
        render "exercises/form_for_media"
      end
    end
  end

  # POST /exercises or /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.user_id = current_user.id

    respond_to do |format|
      if @exercise.save
        format.turbo_stream { redirect_to @exercise, notice: "Exercise was successfully created." }
        format.html { redirect_to @exercise, notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercises/1 or /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.turbo_stream { redirect_to (params[:exercise]['medium_ids'].present? ? edit_exercise_with_step_path(step: 'media') : edit_exercise_path), notice: "Exercise was successfully updated." }
        format.html { redirect_to @exercise, notice: "Exercise was successfully updated." }
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1 or /exercises/1.json
  def destroy
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to exercises_url, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_to_favorites
    if !current_user.favorites.include? params[:id]
        current_user.update_attribute(:favorites, current_user.favorites << params[:id].to_i)
        current_user.save

        # Send html for exercise favorite element
        respond_to do |format|
          format.html { render partial: 'shared/user_favorite', locals: {exercise: @exercise} }
          format.json { render json: current_user.favorites, status: 200 }
        end
    else
      head 404, content_type: "text/html"
    end
  end

  def remove_from_favorites
    if current_user.favorites.include? params[:id]

        current_user.update_attribute(:favorites, current_user.favorites - [params[:id]])
        current_user.save

        # Send html for exercise favorite element
        head 200, content_type: "text/html"
    else
      head 404, content_type: "text/html"
    end
  end

  def add_to_practice
    sessions_of_today = current_user.sessions_of_the_days.find_by(created_at: Date.today)
    new_session = {time: Time.now, exercises:[params[:exercise_id]]}

    if sessions_of_today.present?
      sessions_of_today.sessions << new_session
    else
      sessions_of_today = SessionsOfTheDay.new()
      sessions_of_today.sessions << new_session
    end

    respond_to do |format|
      format.html { render partial: 'sessions_of_the_days/item', collection: current_user.sessions_of_today, as: :session }
      format.json { render json: current_user.sessions_of_today, status: 200 }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exercise_params
      params.fetch(:exercise, {}).permit(:body, :video_link, :title, medium_ids: [])
    end
end
