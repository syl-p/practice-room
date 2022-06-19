class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit get_versions_list update destroy add_to_favorites add_to_practice]
  before_action :set_exerices, only: [:search, :list]
  before_action :set_categories, only: [:index, :search]
  layout "layouts/dashboard", only: %i[edit new me]
  authorize_resource

  # GET /exercises or /exercises.json
  def index
  end

  def list
    render partial: "exercises/search/results", locals: {exercises: @exercises}
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
      format.turbo_stream

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
      render "exercises/versions/new", locals: {exercise: @exercise}
    end
  end

  # GET /exercises/1/edit
  def edit
    if params[:step].present?
      case params[:step]
      when "media"
        @medium = Medium.new
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
    step = @exercise.original.present? ? '' : 'media'

    respond_to do |format|
      if @exercise.save
        format.html { redirect_to edit_with_step_exercises_path(@exercise, step: step), notice: "Exercise was successfully created." }
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
        format.html do
          # get url
          url = request.referer.split('/')
          case url.last
          when 'media'
            redirect_to edit_with_step_exercises_path(@exercise, step: "versions"), notice: "Exercise was successfully updated."
          when "versions"
            redirect_to edit_with_step_exercises_path(@exercise, step: "visibility"), notice: "Exercise was successfully updated."
          else
            if url.last == 'visibility'
              redirect_to edit_with_step_exercises_path(@exercise, step: "visibility"), notice: "Exercise was successfully updated."
            else
              redirect_to edit_with_step_exercises_path(@exercise, step: "media"), notice: "Exercise was successfully updated."
            end
          end
        end
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
                exercise: original,
                versions: original.versions_filtered(current_user)
              }
            )
        }
      end

      # normal
      format.html { redirect_to me_exercises_path, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_to_favorites
    if !current_user.favorites.include? params[:id]
      current_user.update_attribute(:favorites, current_user.favorites << params[:id])
      current_user.save

      # Send html for exercise favorite element
      respond_to do |format|
        format.html { render partial: 'users/favorite', locals: {exercise: @exercise} }
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def set_exerices
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
