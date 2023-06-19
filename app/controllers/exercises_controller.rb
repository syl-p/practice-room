class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[ show edit versions update destroy add_to_favorites add_to_practice]
  before_action :set_exercises_filtered, only: [:search, :list]
  before_action :set_categories, only: [:index, :search]
  authorize_resource

  # GET /exercises or /exercises.json
  def index
    @exercises = Exercise.for_current_user(current_user)
  end

  # POST /exercises/search
  def search
    order_by = params[:order_by].present? ? params[:order_by] : 'created_at'
    order = params[:order].present? ? params[:order] : 'DESC'

    @exercises = @exercises
                      .where(original: nil)
                      .filtered(params)
                      .order(params[:order])

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
    end
  end

  def me
    @exercises = current_user.exercises.where(original: nil)
    render :me
  end

  # GET /exercises/1 or /exercises/1.json
  def show
    @goal_setting = @exercise.goal_setting_for_current_user(current_user)
    unless @goal_setting.present?
      @goal_setting = GoalSetting.new(exercise_id: @exercise.id, user_id: current_user)
    end
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new
  end

  # GET /exercises/1/edit
  def edit
    return unless ['media', "versions", "visibility"].include?(params[:step]) || params[:step].blank?

    if params[:step] == "media"
      @medium = Medium.new
    end
  end

  # POST /exercises or /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.user_id = current_user.id

    respond_to do |format|
      if @exercise.save
        format.html { redirect_to edit_exercise_path(@exercise), notice: "Exercise was successfully created." }
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
          redirect_to request.referrer, notice: "Exercise was successfully updated."
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
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to me_exercises_path, notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_or_remove_favorite
    @exercise = Exercise.find(params[:id])
    case params[:add_or_remove]
    when "add"
      if !current_user.favorites.include? params[:id]
        current_user.update_attribute(:favorites, current_user.favorites << params[:id])
        current_user.save
      end
    when "remove"
      if current_user.favorites.include? params[:id]
        current_user.update_attribute(:favorites, current_user.favorites - [params[:id]])
        current_user.save
      end
    end

    respond_to do |format|
      format.turbo_stream
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
      :body, :video_link, :title, :published, :visibility, :versions_enabled, :exercise_id, :description, :level,
      :goal_start, :goal_end, :goal_label_id,
      medium_ids: [], category_ids: [], levels: [], versions_attributes: %i[
        published user_id id
      ]
    )
  end
end
