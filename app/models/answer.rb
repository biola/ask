class Answer < ActiveRecord::Base

  attr_accessible :question_id, :answer, :choice_id, :uploaded_file, :uploaded_file_cache
  
  belongs_to :answerer, :polymorphic => true
  belongs_to :question
  belongs_to :choice

  validates_presence_of :question_id

  mount_uploader :uploaded_file, UploadedFileUploader

  default_scope joins(:question).order('questions.position').readonly(false)  # This scope prevents updating answers unless readonly is set to false.
  scope :for_answerer, lambda{|answerer| where(:answerer_type => answerer.class.to_s, :answerer_id => answerer.id)}
  scope :for_question, lambda{|question| where(:question_id => question.id)}

  def to_s
    if question.supports_uploads?
      self.uploaded_file.url
    else
      self.answer.to_s
    end
  end

  # This method is used to see if the answer fails to meat "required" status if the question is required.
  #   should return true on fail and nil/false on success.
  def fails_required?
    if question.required
      if question.supports_uploads?
        uploaded_file.blank?
      else
        answer.blank?
      end
    end
  end

end
