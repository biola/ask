class Question < ActiveRecord::Base

  require 'acts_as_list'

  TYPES = ['TextQuestion', 'EssayQuestion', 'ChooseOneQuestion', 'ChecklistQuestion', 'FormSection']  
  
  belongs_to :form
  has_many :choices, :dependent=>:destroy

  acts_as_list :scope=>:form

  attr_accessible :type, :name, :instructions, :required, :choices_attributes, :position
  accepts_nested_attributes_for :choices, :allow_destroy=>true, :reject_if=>lambda{|attrs| attrs['name'].blank? }

  validates_presence_of :type, :name
  validates_inclusion_of :type, :in=>TYPES

  default_scope :order => :position

  def attributes_protected_by_default
    default = [ self.class.primary_key ]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end

  def rhetorical?
    false
  end

  def supports_choices
    false
  end

  def choice_names
    return [] unless supports_choices
    self.choices.map(&:name)
  end

  def supports_multiple_answers?
    false
  end

end
