require 'spec_helper'

describe Submission do
  context "without answers" do
    it "has a valid factory" do
      submission = create(:submission)
      expect(submission).to be_valid
    end
    it "is invalide without a form" do
      expect(build(:submission, form: nil)).not_to be_valid
    end
  end

  context "with answers" do
    it "has a valid factory" do
      submission = create(:submission_with_answers)
      expect(submission).to be_valid
      expect(submission.answers.count).to eq(3)
    end
  end
end
