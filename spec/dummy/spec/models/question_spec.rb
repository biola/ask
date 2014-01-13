require 'spec_helper'

describe Question do
  it "has a valid factory" do
    question = create(:question)
    expect(question).to be_valid
    expect(question.asker_type).to eq "Form"
  end
end