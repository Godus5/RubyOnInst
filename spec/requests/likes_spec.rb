require "rails_helper"

RSpec.describe "Likes", type: :request do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }
  let!(:user_post) { create(:post, user: user) }

  before do
    sign_in account
  end

  describe "POST create" do
    context "creating a record with valid parameters" do
      subject { post post_likes_path(user_post), params: {value: 1} }

      it "the number of likes will increase by 1 and will be redirected to the created post", :aggregate_failures do
        expect { subject }.to change(Like, :count).by(1)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end

    context "creating a record with invalid parameters" do
      subject { post post_likes_path(user_post), params: {value: 0} }

      it "the number of records does not increase and there will be a redirect to the page being viewed", :aggregate_failures do
        expect { subject }.to_not change(Like, :count)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end
  end

  describe "DELETE destroy" do
    let!(:like) { create(:like, user: user, post: user_post) }

    subject { delete post_like_path(user_post.id, like.id) }

    context "request to destroy like" do
      it "the number of likes decreases and redirects to the page with the post", :aggregate_failures do
        expect { subject }.to change(Like, :count).by(-1)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end
  end
end
