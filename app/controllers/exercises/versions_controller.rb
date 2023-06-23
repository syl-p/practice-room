class Exercises::VersionsController < ApplicationController
  before_action :set_exercise , only: %i[index new edit update destroy]
  before_action :set_version , only: %i[edit show edit update destroy]
  def index
    @versions = @exercise.versions_filtered(current_user)
  end

  def show

  end

  def new
    @version = Exercise.new
    @version.user = current_user
    @version.original = @exercise
  end

  def edit

  end

  def create
    @version = Exercise.new(version_params)
    @version.user_id = current_user.id
    respond_to do |format|
      if @version.save
        format.html { redirect_to exercise_version_path(id: @version.id, exercise_id: @version.original.id), notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @version }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @version.update(version_params)
        format.html { redirect_to edit_exercise_version_path(@version), notice: "Exercise was successfully updated." }
        format.json { render :show, status: :ok, location: @version }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @version.destroy
    respond_to do |format|
      format.html { redirect_to exercise_versions_path(@exercise), notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def set_version
    @version = Exercise.find(params[:id])
  end

  def version_params
    params.fetch(:exercise, {}).permit(
      :body, :video_link, :title, :published, :visibility, :versions_enabled, :exercise_id, :description, :level,
      :goal_start, :goal_end, :goal_label_id,
      medium_ids: [], category_ids: [], levels: [], versions_attributes: %i[
        published user_id id
      ]
    )
  end
end
