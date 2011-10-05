class Form < ActiveRecord::Base
  belongs_to :asker, :polymorphic => true
  has_many :submissions
  has_many :questions, :dependent=>:destroy
  has_many :form_sections, :dependent=>:destroy
  has_many :text_questions, :dependent=>:destroy
  has_many :essay_questions, :dependent=>:destroy
  has_many :choose_one_questions, :dependent=>:destroy
  has_many :checklist_questions, :dependent=>:destroy
  
  attr_accessible :name, :instructions, :required, :questions_attributes
  accepts_nested_attributes_for :questions, :allow_destroy=>true, :reject_if=>lambda{|attrs| attrs['name'].blank? }

  validates_presence_of :name#, :type

  scope :required, :conditions=>{ :required=>true }

end
