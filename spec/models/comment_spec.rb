require "rails_helper"

RSpec.describe Comment, type: :model do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }
  let!(:post) { create(:post, user: user) }

  describe "validations" do
    subject { Comment.new(text:, post_id: post.id, user_id: user.id).valid? }

    context "creating a new record with valid attributes" do
      let(:text) { FFaker::Lorem.sentence }

      it "The check runs without errors" do
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
