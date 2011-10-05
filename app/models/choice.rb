class Choice < ActiveRecord::Base

  attr_accessible :name
  
  belongs_to :question

end
