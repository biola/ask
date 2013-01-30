class Form < ActiveRecord::Base
  
  attr_accessible :title
  has_many :submissions, dependent: :destroy

  acts_as_asker

  validates_presence_of :title
  
end
