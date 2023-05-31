class PracticesController < ApplicationController
  before_action :set_practice, only: %i[show edit update destroy]

  # GET /practices or /practices.json
  def index
    @practices = Practice.all
  end

  # GET /practices/1 or /practices/1.json
  def show
  end

  # GET /practices/new
  def new
    @practice = Practice.new
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices or /practices.json
  def create
    @practice = Practice.new(practice_params)

    respond_to do |format|
      if @practice.save
        format.html { redirect_to @practice, notice: "Sessions of the day was successfully created." }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_to_practice
    duration = params[:time].present? ? Time.parse(params[:time]).seconds_since_midnight : 10.minutes
    exercise = Exercise.find(params[:id])
    last_practice = current_user.practices_of_the_day&.last

    if last_practice && (Time.now - last_practice.created_at < 1.hour)
      last_practice.practices_exercises.create(exercise: exercise, duration: duration)
    else
      last_practice = current_user.practices_of_the_day.build
      last_practice.practices_exercises.build(exercise: exercise, duration: duration)
      last_practice.save
    end
  end

  def remove_from_practice
    @practices_exercise = PracticesExercise.find(params[:practices_exercises_id])
    @practices_exercise.destroy

    if @practices_exercise.practice.practices_exercises.count <= 0
      @practices_exercise.practice.destroy
    end
  end

  # PATCH/PUT /practices/1 or /practices/1.json
  def update
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to @practice, notice: "Sessions of the day was successfully updated." }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1 or /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url, notice: "Sessions of the day was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_week
    return unless params[:date].present?
    @current_date = case params[:previous_next]
            when 'previous'
              Date.parse(params[:date]).prev_week
            when 'next'
              Date.parse(params[:date]).next_week
            end

    @practices = current_user.practices.where(created_at: (@current_date.beginning_of_week..@current_date.end_of_week))
    @week_to_show = @current_date.beginning_of_week..@current_date.end_of_week

    respond_to do |format|
      format.html { render partial: 'practices/selector', locals: { current_week: @week_to_show, practices_for_the_week: @practices } }
    end
  end

  def get_day
    @current_date = Date.parse(params[:date])
    @current_week = @current_date.beginning_of_week..@current_date.end_of_week

    @practices_of_the_week = current_user.practices.where(created_at: (@current_date.beginning_of_week..@current_date.end_of_week))
    @practices_of_the_day = @practices_of_the_week.where(created_at: (@current_date.beginning_of_day..@current_date.end_of_day))


    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def practice_params
      params.fetch(:practice, {}).permit(:time)
    end
end
