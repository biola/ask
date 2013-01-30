require 'spec_helper'

describe Form do
  it "has a valid factory" do
    expect(create(:form)).to be_valid
  end
  it "is invalide without a title" do
    expect(build(:form, title: nil)).not_to be_valid
  end
  it "allows for multiple submissions" do
    form = create(:form)
    create(:submission, form: form)
    expect(build(:submission, form: form)).to be_valid
  end
end
