require 'spec_helper'

describe ChecklistQuestion do
  it "has a valid factory" do
    expect(create(:checklist_question)).to be_valid
  end
  it "has 3 options" do
    # this just makes sure the factory is creating options for the question
    expect(create(:checklist_question).choices.count).to eq 3
  end
end