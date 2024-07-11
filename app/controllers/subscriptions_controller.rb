class SubscriptionsController < ApplicationController
  before_action :set_user

  # POST /subscriptions
  def create
    if @user == current_account.user
      redirect_to user_path(@user), alert: "You can't follow your page."
    else
      @subscription = current_account.user.reverse_subscriptions.build(subscription_params)
      if @subscription.save
        redirect_to user_path(@user), notice: "You have successfully subscribed to the user."
      else
        redirect_to user_path(@user), alert: "Error when subscribing."
      end
    end
  end

  # DELETE /subscriptions/1
  def destroy
    if @user == current_account.user
      redirect_to user_path(@user), alert: "You can't unfollow your page."
    else
      @subscription = current_account.user.reverse_subscriptions.find_by(user: @user)
      @subscription.destroy
      redirect_to user_path(@user), notice: "You have successfully unfollowed the user."
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  # Only allow a list of trusted parameters through.
  def subscription_params
    params.permit(:user_id).merge(follower_id: current_account.user.id)
  end
end
