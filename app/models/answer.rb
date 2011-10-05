class Answer < ActiveRecord::Base

  attr_accessible :question_id, :answer, :choice_id
  
  belongs_to :submission
  belongs_to :question
  belongs_to :choice

  validates_presence_of :question_id
  validates_presence_of :answer, :if=>lambda{|answer| !answer.question.is_a?(ChecklistQuestion) && answer.question.required }

  default_scope :joins => :question, :order=>'questions.position'

  def to_s
    self.answer.to_s
  end

end
