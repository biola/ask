require 'Faker'

FactoryGirl.define do

  #### Dummy app models

  factory :form do
    sequence(:title) {|n| "Form #{n}"}

    factory :form_with_questions do
      after(:build) do |form|
        form.questions << build_list(:question, 3, asker: form)
      end
    end
  end

  factory :submission do
    association :form
    
    factory :submission_with_answers do
      association :form, factory: :form_with_questions
      after(:build) do |submission|
        # Build answers based off of form questions
        submission.build_or_create_answers(submission.form.questions)
        submission.answers.each do |answer|
          answer.answer = Faker::Lorem.sentence
        end
      end
    end
  end
    


  
  #### Ask provided models

  factory :question do
    association :asker, factory: :form
    type "TextQuestion"
    sequence(:name) {|n| "Question #{n}"}
    instructions Faker::Lorem.sentence(5)
    required false
    sequence(:position) {|n| n }

    factory :text_question, class: "TextQuestion" do
      type "TextQuestion"
    end
    factory :essay_question, class: "EssayQuestion" do
      type "EssayQuestion"
    end
    factory :choose_one_question, class: "ChooseOneQuestion" do
      type "ChooseOneQuestion"
      after(:build) do |choose_one_question|
        choose_one_question.choices << build_list(:choice, 3, question: choose_one_question)
      end
    end
    factory :checklist_question, class: "ChecklistQuestion" do
      type "ChecklistQuestion"
      
      after(:build) do |checklist_question|
        checklist_question.choices << build_list(:choice, 3, question: checklist_question)
      end
    end
    factory :upload_question, class: "UploadQuestion" do
      type "UploadQuestion"
    end
  end

  factory :choice do
    association :question
    sequence(:name) {|n| "Blue #{n}"}
  end

  factory :answer do
    association :answerer, factory: :submission
    association :question
    answer "Sir Aurthor of Camelot"

    factory :text_answer do
      association :question, factory: :text_question
    end
    factory :essay_answer do
      association :question, factory: :essay_question
    end
    factory :choose_one_answer do
      association :question, factory: :choose_one_question
    end
    factory :checklist_answer do
      association :question, factory: :checklist_question
    end
    factory :upload_answer do
      association :question, factory: :upload_question
      answer nil
      uploaded_file { File.open(File.join(Rails.root, 'spec', 'support', 'files', 'avatar.jpeg')) }
    end
  end
end
