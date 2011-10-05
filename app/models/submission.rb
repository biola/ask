class Submission < ActiveRecord::Base
  
  belongs_to :submitter, :polymorphic => true
  belongs_to :form
  has_many :answers, :include=>:question, :dependent=>:destroy
  has_many :questions, :through=>:answers
  
  attr_accessible :answers_attributes
  accepts_nested_attributes_for :answers, :allow_destroy=>true
  
#  validates_presence_of :form_id, :user_id

  scope :required, :joins=>:form, :conditions=>{ 'forms.required'=>true }

  def find_question(question)
    if question.is_a? Question
      question
    elsif question.is_a? Fixnum
      form.questions.find_by_id(question)
    else
      form.questions.find_by_name(question.to_s)
    end
  end

  def [](question)
    default = super
    if default
      default
    else
     answer_to(find_question(question))
    end
  end

  def answer_to(question)
    return nil if question.nil?
    if question.supports_multiple_answers?
      answers_to(question)
    else
      answers.find_by_question_id(question.id)
    end
  end

  def answers_to(question)
    return nil if question.nil?
    answers.find_all_by_question_id(question.id)
  end
  
  def build_or_create_answers
    method = new_record? ? :build : :create
    
    form.questions.each do |question|
      if answers_to(question).empty?
      
        if question.supports_multiple_answers?
          question.choices.each do |choice|
            answers.send(method, :question_id=>question.id, :answer=>'', :choice_id=>choice.id)
          end
        else
          answers.send(method, :question_id=>question.id)
        end
        
      end
    end
  end
  
  def questions_with_answers
    qa = ActiveSupport::OrderedHash.new
    
    # Set the correct order and make sure we have all the questions
    form.questions.each do |q|
      qa[q.name] = []
    end
    
    answers.each do |a|
      qa[a.question.name] << a.answer.to_s.strip unless a.answer.blank?
    end
    
    qa
  end

  def required?
    form.required?
  end

  def completed?
    !created_at.nil?
  end

  def status
    if completed?
      'completed' + (submitter_name ? " by #{submitter_name}" : '')
    else
      'incomplete'
    end
  end

end
