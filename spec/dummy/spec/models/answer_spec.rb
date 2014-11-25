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

  it "correctly fails when required but not answered" do
    answer = create(:answer, answer: "")
    answer.question.required = true
    expect(answer).to be_valid
    expect(answer.fails_required?).to be_truthy

    upload_answer = create(:upload_answer, uploaded_file: "")
    upload_answer.question.required = true
    expect(upload_answer).to be_valid
    expect(upload_answer.fails_required?).to be_truthy
  end

  it "correctly passes when required and answered" do
    answer = create(:answer)
    answer.question.required = true
    expect(answer).to be_valid
    expect(answer.fails_required?).to be_falsey

    upload_answer = create(:upload_answer)
    upload_answer.question.required = true
    expect(upload_answer).to be_valid
    expect(upload_answer.fails_required?).to be_falsey
  end
end
