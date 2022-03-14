class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit get_versions_list update destroy add_to_favorites add_to_practice]
  before_action :set_exerices_list, only: [:index, :search]
  authorize_resource

  # specific layout for manage actions
  layout "layouts/dashboard", only: %i[edit new me]

  # GET /exercises or /exercises.json
  def index
  end

  # POST /exercises/search
  def search
    order_by = params[:order_by].present? ? params[:order_by] : 'created_at'
    order = params[:order].present? ? params[:order] : 'DESC'

    @exercises = @exercises
                      .where(original: nil)
                      .filtered(params)
                      .order("#{params[:order_by]} #{params[:order]}")

    if params[:category_ids].present? && params[:category_ids].count > 0
      @exercises = @exercises.joins(:categories).where(categories: params[:category_ids])
    end

    if params[:levels].present? && params[:levels].count > 0
      @exercises = @exercises.where(level: params[:levels])
    end

    if params[:visibility].present?
      case params[:visibility]
      when "friends"
        @exercises = @exercises.joins(:user).where(users: {id: current_user.friends})
      end
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "search_results",
            partial: "exercises/search/list",
            locals: {exercises: @exercises, categories: @categories}
          )
      }

      format.html {
        render partial: "exercises/search/list", locals: {exercises: @exercises, categories: @categories}
      }
    end
  end

  def get_versions_list
    render partial: "exercises/versions/list", locals: {
      versions: @exercise.versions_filtered(current_user),
      exercise: @exercise
    }
  end

  def me
    @exercises = current_user.exercises.where(original: nil)
    render :me
  end

  # GET /exercises/1 or /exercises/1.json
  def show
    if params[:view].present?
      render "exercises/versions/show"
    end
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new

    if params[:exercise_id].present? # version ?
      @exercise.exercise_id = params[:exercise_id]
      render "exercises/versions/new"
    end
  end

  # GET /exercises/1/edit
  def edit
    if params[:step].present?
      case params[:step]
      when "media"
        render "exercises/form/media"
      when "versions"
        render "exercises/form/versions"
      when "visibility"
        render "exercises/form/visibility"
      end
    else
      if @exercise.original.present? # it's a version
        render "exercises/versions/edit"
      end
    end
  end

  # POST /exercises or /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.user_id = current_user.id

    # published false if is a version of an exercise
    @exercise.published = false if @exercise.original.present?

    respond_to do |format|
      if @exercise.save
        format.turbo_stream {
          path = if @exercise.original.present? # it's a new version
            exercise_path(@exercise, view: 'versions')
          else
            edit_exercise_path(@exercise) + '/media' # redirect to media step
          end
          redirect_to path, notice: "Exercise was successfully created."
        }
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
        step_layout = if params[:exercise]['medium_ids'].present?
          edit_with_step_exercises_path(step: 'media')
        elsif params[:exercise]['versions_attributes'].present?
          edit_with_step_exercises_path(step: 'versions')
        else
          edit_exercise_path
        end

        format.turbo_stream { redirect_to step_layout, notice: "Exercise was successfully updated." }
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
    original = @exercise.original
    @exercise.destroy
    respond_to do |format|

      if original.present? # it's a version
        # turbo respond for get_versions_list
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "exercise_versions",
              partial: "exercises/versions/list",
              locals: {
                exercise: @exercise,
                versions: @exercise.original.versions_filtered
              }
            )
        }
      end

      # normal
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
    # default duration is 10 minutes (600 seconds)
    duration = params[:time].present? ? Time.parse(params[:time]).seconds_since_midnight : 600
    sessions_of_today = current_user.sessions_of_today

    # exercise practiced
    practiced = {exercise: @exercise, duration: duration}

    # prepare new session
    new_session = {time: Time.now, exercises:[]}
    new_session[:exercises] << practiced

    if !sessions_of_today.present? # no session today
      sessions_of_today = SessionsOfTheDay.new(user_id: current_user.id)
    end

    if sessions_of_today.sessions.count > 0  && ((Time.now - sessions_of_today.sessions.last["time"].to_time) <= 1.hour)
      sessions_of_today.sessions.last["exercises"] << practiced
    else
      sessions_of_today.sessions << new_session
    end
    sessions_of_today.save

    respond_to do |format|
      format.html { render partial: 'sessions_of_the_days/list', locals: { sessions_of_the_day: sessions_of_today } }
      format.json { render json: new_session, status: 200 }
    end
  end

  def remove_from_practice
    sessions_of_the_day = SessionsOfTheDay.find(params[:sessions_of_the_day_id])
    sessions_of_the_day.sessions[params[:session_index].to_i]["exercises"].delete_at(params[:index].to_i) if session
    sessions_of_the_day.save

    if sessions_of_the_day.sessions[params[:session_index].to_i]["exercises"].count <= 0
      sessions_of_the_day.sessions.delete_at(params[:session_index].to_i)
      sessions_of_the_day.save

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("practice_session_#{params[:sessions_of_the_day_id]}_#{params[:session_index]}")
        end
      end
    else

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("practice_exercise_#{params[:index]}_#{params[:sessions_of_the_day_id]}_#{params[:session_index]}")
        end
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def set_exerices_list
    @categories = Category.all
    # if connected show published exercise and my private exercise
    @exercises = Exercise.for_current_user(current_user)
  end

  # Only allow a list of trusted parameters through.
  def exercise_params
    params.fetch(:exercise, {}).permit(
      :body, :video_link, :title, :published, :visibility, :versions_enabled, :exercise_id, :description, :level, medium_ids: [], category_ids: [], levels: [], versions_attributes: %i[
        published user_id id
      ]
    )
  end
end
