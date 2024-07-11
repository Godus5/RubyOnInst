require "rails_helper"

RSpec.describe "Comments", type: :request do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }
  let!(:user_post) { create(:post, user: user) }

  before do
    sign_in account
  end

  describe "POST create" do
    context "request to create a comment for a post" do
      let!(:valid_params) do
        {comment: {text: "Nice post!"}}
      end

      subject { post post_comments_path(user_post), params: valid_params }

      it "the comment will be created and redirected to the post being viewed", :aggregate_failures do
        expect { subject }.to change(Comment, :count).by(1)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end

    context "creating a record with invalid parameters" do
      let!(:invalid_params) do
        {comment: {text: ""}}
      end

      subject { post post_comments_path(user_post), params: invalid_params }

      it "the number of records does not increase and redirected to the post being viewed", :aggregate_failures do
        expect { subject }.to_not change(Comment, :count)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end
  end

  describe "DELETE destroy" do
    context "request to delete your comment" do
      let!(:comment) { create(:comment, user: user, post: user_post) }

      subject { delete post_comment_path(user_post.id, comment.id) }

      it "the number of comments decreases and redirected to the post being viewed", :aggregate_failures do
        expect { subject }.to change(Comment, :count).by(-1)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end

    context "request to delete someone else's comment" do
      let!(:another_account) { create(:account) }
      let!(:second_user) { create(:user, account: another_account) }
      let!(:comment) { create(:comment, user: second_user, post: user_post) }

      subject { delete post_comment_path(user_post.id, comment.id) }

      it "the number of records does not increase and redirected to the post being viewed", :aggregate_failures do
        expect { subject }.to_not change(Comment, :count)
        expect(subject).to redirect_to(post_url(user_post.id))
      end
    end
  end
end
