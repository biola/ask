require 'spec_helper'

describe ChooseOneQuestion do
  it "has a valid factory" do
    question = create(:choose_one_question)
    expect(question).to be_valid
    expect(question.asker_type).to eq("Form")
    expect(question.choices.count).to eq(3)
  end
end