class Submission < ActiveRecord::Base
  
  belongs_to :form
  validates_presence_of :form

  acts_as_answerer

  def asker  
    return form  
  end
end
