require "rails_helper"

describe AnswerPolicy do
  let(:user) { build_stubbed :user }
  let(:record) { build_stubbed :answer }

  subject { described_class }

  permissions :manage? do
    it "is successful when user is author" do
      record.user = user
      is_expected.to permit(user, record)
    end

    it "fails when user is not owner" do
      is_expected.not_to permit(user, record)
    end
  end

  permissions :best? do
    it "is successful when user is question's author" do
      record.question.user = user
      is_expected.to permit(user, record)
    end

    it "fails when user is not owner" do
      is_expected.not_to permit(user, record)
    end
  end
end
