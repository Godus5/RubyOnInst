require "rails_helper"

RSpec.describe Subscription, type: :model do
  let!(:account_user) { create(:account) }
  let!(:account_follower) { create(:account) }
  let!(:user) { create(:user, account: account_user) }
  let!(:follower) { create(:user, account: account_follower) }

  describe "search for subscriptions per user" do
    subject { user.subscriptions }

    context "the user has a follower" do
      before do
        Subscription.create(user: user, follower: follower)
      end

      it "returns a list of subscription entries for this user" do
        expect(subject).to eq(Subscription.where(user: user, follower: follower))
      end
    end
  end

  describe "search for subscribers from a user" do
    subject { user.followers }

    context "the user has a follower" do
      before do
        Subscription.create(user: user, follower: follower)
      end

      it "will return a list of this user's subscribers" do
        expect(subject).to eq(User.where(id: follower.id))
      end
    end
  end

  describe "search for follower's subscriptions" do
    subject { follower.reverse_subscriptions }

    context "the user has a follower" do
      before do
        Subscription.create(user: user, follower: follower)
      end

      it "returns a list of user subscriptions" do
        expect(subject).to eq(Subscription.where(user: user, follower: follower))
      end
    end
  end

  describe "search for a list of users the current user is following" do
    subject { follower.following }

    context "the user has a follower" do
      before do
        Subscription.create(user: user, follower: follower)
      end

      it "returns a list of users the current user is following" do
        expect(subject).to eq(User.where(id: user.id))
      end
    end
  end
end
