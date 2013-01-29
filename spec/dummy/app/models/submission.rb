class Submission < ActiveRecord::Base
  
  # attr_accessible :title, :body
  belongs_to :form

  acts_as_answerer

  def asker  
    return form  
  end
end
