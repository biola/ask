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
    name "What is your name?"
    instructions "Please type quickly"
    required false
    sequence(:position) {|n| n }

    factory :text_question do
      type "TextQuestion"
    end
    factory :essay_question do
      type "EssayQuestion"
    end
    factory :choose_one_question do
      type "ChooseOneQuestion"
      after(:build) do |choose_one_question|
        choose_one_question.choices << build_list(:choice, 3, question: choose_one_question)
      end
    end
    factory :checklist_question do
      type "ChecklistQuestion"
      after(:build) do |choose_one_question|
        choose_one_question.choices << build_list(:choice, 3, question: choose_one_question)
      end
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
    # Note: type gets set automatically before save based on the question type.

    factory :text_answer do
    end
    factory :essay_answer do
    end
    factory :choose_one_answer do
      after(:build) do |choose_one_answer|
        choose_one_answer.choices << build_list(:choice, 3, answer: choose_one_answer)
      end
    end
    factory :checklist_answer do
      after(:build) do |choose_one_answer|
        choose_one_answer.choices << build_list(:choice, 3, answer: choose_one_answer)
      end
    end
  end
end
