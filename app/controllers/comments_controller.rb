class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ show edit update destroy ]
  authorize_resource

  # GET /media/1 or /media/1.json
  def show
  end

  # GET /media/1/edit
  def edit
  end

  # PATCH/PUT /media/1 or /media/1.json
  def update
    if @comment.update(comment_params)
      redirect_to @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /media/1 or /media/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove("comment_#{@comment.id}")
      }
      format.html { redirect_to @comment.commentable }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
