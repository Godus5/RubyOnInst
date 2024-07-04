class SubscriptionsController < ApplicationController
  # POST /subscriptions
  def create
    user = User.find(params[:user_id])
    subscription = current_account.user.reverse_subscriptions.build(user: user)
    if subscription.save
      redirect_to user_path(user), notice: "You have successfully subscribed to the user."
    else
      redirect_to user_path(user), alert: "Error when subscribing."
    end
  end

  # DELETE /subscriptions/1
  def destroy
    user = User.find(params[:user_id])
    current_account.user.following.delete(user)
    redirect_to user_path(user), notice: "You have successfully unfollowed the user."
  end
end
