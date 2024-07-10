class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :user_exist
  before_action :post_owner, only: %i[edit update destroy]

  # GET /posts
  def index
    following_posts = Post.joins(user: :followers)
      .where(subscriptions: {follower_id: current_account.user.id})

    own_posts = Post.where(user_id: current_account.user.id)

    @posts = Post.where(id: following_posts.pluck(:id) + own_posts.pluck(:id))
      .order(created_at: :desc)
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
    redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def user_exist
    unless current_account.user
      redirect_to new_user_path, alert: "To continue working on the site, you need to create your own page."
    end
  end

  def post_owner
    unless @post.user == current_account.user
      redirect_to @post, alert: "You are not the owner of this post."
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:text, :photo).merge(user_id: current_account.user.id)
  end
end
