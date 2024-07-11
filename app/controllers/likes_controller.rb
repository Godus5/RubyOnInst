class LikesController < ApplicationController
  before_action :set_post

  # POST /likes
  def create
    @like = @post.likes.find_or_initialize_by(user: current_account.user)

    if @like.update(like_params)
      redirect_to @post, notice: "Your feedback has been recorded."
    else
      redirect_to @post, alert: @like.errors.full_messages.join(", ")
    end
  end

  # DELETE /likes/1
  def destroy
    @like = @post.likes.find_by(user: current_account.user)
    @like.destroy!
    redirect_to @post, notice: "Like was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:post_id])
  end

  def like_params
    params.require(:like).permit(:value)
  end
end
