require 'spec_helper'

describe Answer do
  it "has a valid factory" do
    answer = create(:answer)
    expect(answer).to be_valid
    expect(answer.answerer_type).to eq("Submission")
    expect(answer.type).to eq("TextAnswer")
  end
  it "is invalid without a question" do
    expect(build(:answer, question: nil)).not_to be_valid
  end
  it "sets it's own type on save based on the question type" do
    answer = build(:answer)
    expect(answer.type).to eq(nil)
    answer.save
    expect(answer.type).to eq("TextAnswer")
  end
end
