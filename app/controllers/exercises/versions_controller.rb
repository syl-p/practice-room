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
    @version = Exercise.new(exercise_params)
    @version.user_id = current_user.id
    respond_to do |format|
      if @exercise.save
        format.html { redirect_to edit_exercise_version_path(@version), notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @version }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @version.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @version.update(exercise_params)
      format.html do
        redirect_to request.referrer, notice: "Version was successfully updated."
      end
      format.json { render :show, status: :ok, location: @exercise }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @exercise.errors, status: :unprocessable_entity }
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
end
