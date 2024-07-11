require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:account) { create(:account) }

  before do
    sign_in account
  end

  describe "GET show" do
    subject { get user_path(user.id) }
    let!(:user) { create(:user, account: account) }

    context "request for withdrawal of a specific user" do
      it "render the show page" do
        expect(subject).to render_template(:show)
      end
    end
  end

  describe "GET new" do
    subject { get new_user_path }

    context "request page to create a new user" do
      it "render the new page" do
        expect(subject).to render_template(:new)
      end
    end

    context "the user page has already been created and a request is made to create a new entry for the current account" do
      before do
        create(:user, account: account)
      end
      it "redirects to the root page" do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

  describe "GET edit" do
    subject { get edit_user_url(user.id) }
    let!(:user) { create(:user, account: account) }

    context "the owner submits a form request to edit his user page" do
      it "renders a form for editing the user page" do
        expect(subject).to render_template(:edit)
      end
    end

    context "the user tries to open a form to edit the page without being its owner" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }

      before do
        sign_out account
        sign_in another_account
      end

      it "redirects to the page being viewed and does not render the page edit form", :aggregate_failures do
        expect(subject).to redirect_to(user_url(user.id))
        expect(subject).not_to render_template(:edit)
      end
    end
  end

  describe "POST create" do
    context "creating a record with valid values" do
      let(:valid_params) do
        {user: {first_name: "first name", last_name: "last name", nickname: "Godus"}}
      end
      subject { post users_path, params: valid_params }

      it "the number of entries will increase by 1 and will be redirected to the root page", :aggregate_failures do
        expect { subject }.to change(User, :count).by(1)
        expect(subject).to redirect_to(root_path)
      end
    end

    context "creating a record with invalid values" do
      let(:invalid_params) { {user: {first_name: "", last_name: "last name", nickname: "Godus"}} }
      subject { post users_path, params: invalid_params }

      it "the number of records does not increase and the page with the creation form will be rendered again", :aggregate_failures do
        expect { subject }.to_not change(User, :count)
        expect(subject).to render_template(:new)
      end
    end
  end

  describe "PATCH update" do
    let!(:user) { create(:user, account: account) }

    context "updating a record with valid data entered" do
      let(:valid_params) do
        {user: {first_name: "Anton"}}
      end
      subject { patch user_path(user), params: valid_params }

      it "redirects to the updated user page" do
        expect(subject).to redirect_to(user_url(user.id))
      end
    end

    context "updating a record with invalid data entered" do
      let(:invalid_params) do
        {user: {first_name: ""}}
      end
      subject { patch user_path(user), params: invalid_params }

      it "render edit page to correct entered data" do
        expect(subject).to render_template(:edit)
      end
    end

    context "the user tries to update the page without being its owner" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }
      let(:valid_params) do
        {user: {first_name: "Anton"}}
      end
      subject { patch user_path(user), params: valid_params }

      before do
        sign_out account
        sign_in another_account
      end

      it "redirects to the page being viewed and the user will not be updated", :aggregate_failures do
        expect(subject).to redirect_to(user_url(user.id))
        expect(user.created_at).to eq(user.updated_at)
      end
    end
  end

  describe "DELETE destroy" do
    subject { delete user_path(user) }
    let!(:user) { create(:user, account: account) }

    context "request to destroy user page" do
      it "the number of records decreases and redirects to the authorization page", :aggregate_failures do
        expect { subject }.to change(User, :count).by(-1)
        expect(subject).to redirect_to(new_account_session_url)
      end
    end

    context "the user tries to destroy the page without being its owner" do
      let!(:another_account) { create(:account) }
      let!(:another_user) { create(:user, account: another_account) }

      before do
        sign_out account
        sign_in another_account
      end

      it "redirects to the page being viewed and the user will not destroy", :aggregate_failures do
        expect(subject).to redirect_to(user_url(user.id))
        expect(account.user.nil?).not_to eq(true)
      end
    end
  end
end
