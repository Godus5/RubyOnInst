require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }

  let!(:follower_account) { create(:account) }
  let!(:follower) { create(:user, account: follower_account) }

  before do
    sign_in follower_account
  end

  describe "POST create" do
    context "user subscription request" do
      let!(:valid_params) do
        {subscription: {user_id: user.id}}
      end

      subject { post user_subscription_path(user), params: valid_params }

      it "creates a subscription and redirects to the user page", :aggregate_failures do
        expect { subject }.to change(Subscription, :count).by(1)
        expect(subject).to redirect_to(user_url(user.id))
      end

      it "faking a recording error", :aggregate_failures do
        allow_any_instance_of(Subscription).to receive(:save).and_return(false)
        expect { subject }.not_to change(Subscription, :count)
        expect(subject).to redirect_to(user_url(user.id))
      end
    end

    context "self-subscription request" do
      let!(:invalid_params) do
        {subscription: {user_id: follower.id}}
      end

      subject { post user_subscription_path(follower), params: invalid_params }

      it "the number of records does not increase and will be redirected to the user being viewed", :aggregate_failures do
        expect { subject }.to_not change(Subscription, :count)
        expect(subject).to redirect_to(user_url(follower.id))
      end
    end
  end

  describe "DELETE destroy" do
    let!(:subscription) { create(:subscription, user: user, follower: follower) }

    context "request to unsubscribe from a user" do
      subject { delete user_subscription_path(user) }

      it "the number of subscriptions decreases and will be redirected to the user being viewed", :aggregate_failures do
        expect { subject }.to change(Subscription, :count).by(-1)
        expect(subject).to redirect_to(user_url(user.id))
      end
    end

    context "self-unsubscribe request" do
      subject { delete user_subscription_path(follower) }

      it "the number of subscriptions will not decrease and will be redirected to the user’s page being viewed", :aggregate_failures do
        expect { subject }.to_not change(Subscription, :count)
        expect(subject).to redirect_to(user_url(follower.id))
      end
    end
  end
end
