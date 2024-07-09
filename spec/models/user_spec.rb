require "rails_helper"

RSpec.describe User, type: :model do
  let!(:account) { create(:account) }

  describe "validations" do
    subject { User.new(first_name:, last_name:, account_id: account.id, nickname:, bio:).valid? }

    context "creating a new record with valid attributes" do
      let(:first_name) { FFaker::Name.first_name }
      let(:last_name) { FFaker::Name.last_name }
      let(:nickname) { FFaker::Internet.user_name }
      let(:bio) { FFaker::Lorem.paragraph }
      it "check is performed with errors" do
        expect(subject).to eq(true)
      end
    end

    context "creating a new record with invalid attributes" do
      let(:first_name) { FFaker::Name.first_name }
      let(:last_name) { FFaker::Name.last_name }
      let(:nickname) { "" }
      let(:bio) { FFaker::Lorem.paragraph }

      it "check is performed with errors" do
        expect(subject).to eq(false)
      end
    end
  end
end
