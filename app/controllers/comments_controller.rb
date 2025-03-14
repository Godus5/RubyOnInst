class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # POST /comments
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, alert: "There was an error creating your comment."
    end
  end

  # DELETE /comments/1
  def destroy
    if @comment.user == current_account.user
      @comment.destroy!
      redirect_to @comment.post, notice: "Comment was successfully destroyed."
    else
      redirect_to @comment.post, alert: "You are not the creator of this comment."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:text, :post_id).merge(user_id: current_account.user.id)
  end
end
