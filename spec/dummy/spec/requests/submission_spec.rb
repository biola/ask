require 'spec_helper'

describe "Submissions" do
  it "Creates a new Submission" do
    form = create(:form_with_questions)
    visit form_path(form)
    click_link "Fill Out Form"
    
    # You should now be on the form submission page
    expect(current_path).to eql new_form_submission_path(form)
    expect{
      fill_in "submission_answers_attributes_0_answer", with: "Bannana"
      fill_in "submission_answers_attributes_1_answer", with: "Monkey"
      click_button "Submit Form"
    }.to change(Submission, :count).by 1
  end
end
