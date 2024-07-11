require "rails_helper"

RSpec.describe Post, type: :model do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }

  describe "validations" do
    subject { Post.new(text:, user_id: user.id).valid? }

    context "creating a new record with valid attributes" do
      let(:text) { FFaker::Lorem.paragraph }

      it "check is performed with errors" do
        expect(subject).to eq(true)
      end
    end

    context "creating a new record with invalid attributes" do
      let(:text) { nil }

      it "check is performed with errors" do
        expect(subject).to eq(false)
      end
    end
  end
end
