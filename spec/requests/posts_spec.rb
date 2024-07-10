require "rails_helper"

RSpec.describe "Posts", type: :request do
  let!(:account) { create(:account) }

  before do
    sign_in account
  end

  describe "GET index" do
    subject { get posts_path }

    context "request to view posts of interest to the user" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }

      it "render page index" do
        expect(subject).to render_template(:index)
      end
    end

    context "executing a query with a non-existent user" do
      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "GET show" do
    subject { get post_path(post.id) }

    context "request to show post" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }

      it "render page show" do
        expect(subject).to render_template(:show)
      end
    end

    context "executing a query with a non-existent user" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }

      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "GET new" do
    subject { get new_post_path }

    context "request for a form to create a new post" do
      let!(:user) { create(:user, account: account) }

      it "rendering of a page with a form for creating a new post" do
        expect(subject).to render_template(:new)
      end
    end

    context "executing a query with a non-existent user" do
      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "GET edit" do
    subject { get edit_post_path(post.id) }

    context "request for a form to edit a post" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }

      it "rendering of a form for editing a post" do
        expect(subject).to render_template(:edit)
      end
    end

    context "executing a query with a non-existent user" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }

      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "POST create" do
    context "creating a record with valid values" do
      let!(:user) { create(:user, account: account) }
      let(:valid_params) do
        { post: { text: "I like ruby!", user_id: user.id } }
      end

      subject { post posts_path, params: valid_params }

      it "the number of posts will increase by 1 and will be redirected to the created post", :aggregate_failures do
        expect { subject }.to change(Post, :count).by(1)
        expect(subject).to redirect_to(post_path(Post.last.id))
      end
    end

    context "creating a record with invalid values" do
      let!(:user) { create(:user, account: account) }
      let(:invalid_params) do
        { post: { text: "", user_id: user.id } }
      end

      subject { post posts_path, params: invalid_params }

      it "the number of records does not increase and the page with the creation form will be rendered again", :aggregate_failures do
        expect { subject }.to_not change(Post, :count)
        expect(subject).to render_template(:new)
      end
    end

    context "executing a query with a non-existent user" do
      let(:params) do
        { post: { text: "I like ruby!", user_id: nil } }
      end

      subject { post posts_path, params: params }

      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "PATCH update" do
    context "updating a record with valid data entered" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }
      let(:valid_params) do
        { post: { text: "I like ruby!" } }
      end

      subject { patch post_path(post), params: valid_params }

      it "redirects to the updated post page" do
        expect(subject).to redirect_to(post_url(post.id))
      end
    end

    context "updating a record with invalid data entered" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }
      let(:invalid_params) do
        { post: { text: "" } }
      end

      subject { patch post_path(post), params: invalid_params }

      it "render edit page to correct entered data" do
        expect(subject).to render_template(:edit)
      end
    end

    context "the user tries to update the post without being its owner" do
      let!(:user) { create(:user, account: account) }
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }

      let(:valid_params) do
        { post: { text: "I like ruby!" } }
      end

      subject { patch post_path(post), params: valid_params }

      before do
        sign_out account
        sign_in another_account
      end

      it "redirects to the page being viewed and the post will not be updated", :aggregate_failures do
        expect(subject).to redirect_to(post_url(post.id))
        expect(post.created_at).to eq(post.updated_at)
      end
    end

    context "executing a query with a non-existent user" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }
      let(:valid_params) do
        { post: { text: "I like ruby!" } }
      end

      subject { patch post_path(post), params: valid_params }

      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete post_path(post) }

    context "request to destroy post by owner" do
      let!(:user) { create(:user, account: account) }
      let!(:post) { create(:post, user: user) }

      it "the number of records decreases and the page index is rendered", :aggregate_failures do
        expect { subject }.to change(Post, :count).by(-1)
        expect(subject).to redirect_to(posts_url)
      end
    end

    context "the user tries to destroy the page without being its owner" do
      let!(:user) { create(:user, account: account) }
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }

      it "redirects to the page being viewed and the user will not destroy", :aggregate_failures do
        expect(subject).to redirect_to(post_url(post.id))
        expect(account.user.nil?).not_to eq(true)
      end
    end

    context "executing a query with a non-existent user" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let!(:post) { create(:post, user: another_user) }

      it "redirect to the form to create a user page" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end
end
