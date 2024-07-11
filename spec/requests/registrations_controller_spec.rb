require "rails_helper"

RSpec.describe "RegistrationsControllers", type: :request do
  describe "POST create" do
    context "registration request and account creation" do
      let!(:password) { FFaker::Internet.password }
      let!(:account_params) do
        {
          account: {
            email: FFaker::Internet.email,
            password: password,
            password_confirmation: password
          }
        }
      end

      subject { post account_registration_path, params: account_params }

      it "redirects to the new user path" do
        expect(subject).to redirect_to(new_user_path)
      end
    end
  end
end
