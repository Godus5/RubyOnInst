require "rails_helper"

RSpec.describe Like, type: :model do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account: account) }
  let!(:post) { create(:post, user: user) }

  describe "validations" do
    subject { Like.new(value:, post_id: post.id, user_id: user.id).valid? }

    context "creating a new record with valid attributes" do
      let(:value) { -1 }

      it "The check runs without errors" do
        expect(subject).to eq(true)
      end
    end

    context "creating a new record with the same attribute" do
      before do
        Like.create(value: 1, post_id: post.id, user_id: user.id)
      end
      let(:value) { 1 }

      it "check is performed with errors" do
        expect(subject).to eq(false)
      end
    end
  end
end
