class Exercises::GoalSettingsController < ApplicationController
  before_action :set_goal_setting, only: %i[ show update destroy ]

  def create
    @goal_setting = GoalSetting.new(goal_setting_params)
    @goal_setting.user = current_user
    @goal_setting.save
    byebug
    # respond_to do |format|
    #   if @goal_setting.save
    #     format.html { redirect_to @goal_setting, notice: "Category was successfully created." }
    #     format.json { render :show, status: :created, location: @goal_setting }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @goal_setting.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update
    respond_to do |format|
      if @goal_setting.update(goal_setting_params)
        # format.html { redirect_to @category, notice: "Category was successfully updated." }
        # format.json { render :show, status: :ok, location: @category }
      else
        # format.html { render :edit, status: :unprocessable_entity }
        # format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @goal_setting.destroy
  end

  private
  def set_goal_setting
    @goal_setting = GoalSetting.find(params[:id])
  end

  def goal_setting_params
    params.require(:goal_setting).permit(:value, :exercise_id)
  end
end
