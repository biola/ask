require 'spec_helper'

describe Answer do
  it "has a valid factory" do
    answer = create(:answer)
    expect(answer).to be_valid
    expect(answer.answerer_type).to eq "Submission"
  end
  it "is invalid without a question" do
    expect(build(:answer, question: nil)).not_to be_valid
  end
end
