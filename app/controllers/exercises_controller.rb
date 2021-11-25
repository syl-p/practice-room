class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit get_versions_list update destroy add_to_favorites ]
  authorize_resource

  # specific layout for manage actions
  layout "layouts/dashboard", only: %i[edit new me]

  # GET /exercises or /exercises.json
  def index
    @exercises = Exercise.filtered(params).where(original: nil)
    if params[:export].present?
      render partial: "exercises/list", locals: {exercises: @exercises}
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
        render "exercises/form_for_media"
      when "versions"
        render "exercises/form_for_versions"
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

    respond_to do |format|
      if @exercise.save
        format.turbo_stream {
 redirect_to exercise_path(@exercise, view: "version"), notice: "Exercise was successfully created." }
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
    sessions_of_today = current_user.sessions_of_today
    new_session = {time: Time.now, exercises:[params[:id]]}

    if !sessions_of_today.present?
      sessions_of_today = SessionsOfTheDay.new(user_id: current_user.id)
    end

    if sessions_of_today.sessions.count > 0  && ((Time.now - sessions_of_today.sessions.last["time"].to_time) <= 1.hour)
      sessions_of_today.sessions.last["exercises"] << params[:id]
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
    sessions_of_the_day.sessions[params[:session_index].to_i]["exercises"].delete(params[:id]) if session
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
          render turbo_stream: turbo_stream.remove("practice_exercise_#{params[:id]}_#{params[:sessions_of_the_day_id]}_#{params[:session_index]}")
        end
      end
    end


  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exercise_params
    params.fetch(:exercise, {}).permit(
      :body, :video_link, :title, :published, :exercise_id, :description, medium_ids: [], category_ids: [], versions_attributes: %i[
        published user_id id
      ]
    )
  end
end
