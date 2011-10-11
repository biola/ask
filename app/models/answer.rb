class Answer < ActiveRecord::Base

  attr_accessible :question_id, :answer, :choice_id
  
  belongs_to :answerer, :polymorphic => true
  belongs_to :question
  belongs_to :choice

  validates_presence_of :question_id

  default_scope joins(:question).order('questions.position')
  scope :for_answerer, lambda{|answerer| where(:answerer_type => answerer.class.to_s, :answerer_id => answerer.id)}
  scope :for_question, lambda{|question| where(:question_id => question.id)}

  def to_s
    self.answer.to_s
  end

end
