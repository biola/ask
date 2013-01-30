require 'spec_helper'

describe ChooseOneQuestion do
  it "has a valid factory" do
    expect(create(:choose_one_question)).to be_valid
  end
  it "has 3 choices" do
    # this just makes sure the factory is creating choices for the question
    expect(create(:choose_one_question).choices.count).to eq 3
  end
end