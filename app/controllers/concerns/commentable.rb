module Commentable
    extend ActiveSupport::Concern
    include ActionView::RecordIdentifier
    include RecordHelper
    included do
        before_action :authenticate_user!
    end

    def create
        @comment = @commentable.comments.new(comment_params)
        @comment.user = current_user
        @comment.parent_id = @parent&.id

        respond_to do |format|
            if @comment.save
                # comment = Comment.new
                replace_target = @parent ? @parent : @commentable
                # puts record_id_gen(replace_target, @comment)


                format.turbo_stream {  
                    render turbo_stream: turbo_stream
                        .prepend("#{dom_id(@parent || @commentable)}_comments",
                            partial: "comments/comment",
                            locals: {comment: @comment, commentable: replace_target })
                        # .replace(record_id_gen(replace_target, comment), # Replace form by empty form fields
                        #     partial: "comments/form",
                        #     locals: {comment: comment, commentable: replace_target }
                        # )
                }
                format.html { 
                    redirect_to @commentable 
                }
            else
                # puts @parent || @commentable
                # puts record_id_gen(@parent || @commentable, @comment)
                format.turbo_stream { 
                    render turbo_stream: turbo_stream.replace(record_id_gen(@parent || @commentable, @comment),
                        partial: "comments/form",
                        locals: {comment: @comment, commentable: replace_target }
                    )
                }
                format.html { 
                    redirect_to replace_target 
                }
    
            end
        end
    end

    private
        def comment_params
            params.require(:comment).permit(:body, :parent_id)
        end
end