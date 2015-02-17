class Form < ActiveRecord::Base

  has_many :submissions, dependent: :destroy

  acts_as_asker

  validates_presence_of :title

end
