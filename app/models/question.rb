class Question < ActiveRecord::Base
  require 'acts_as_list'

  TYPES = ['TextQuestion', 'EssayQuestion', 'ChooseOneQuestion', 'ChecklistQuestion', 'UploadQuestion', 'FormSection']

  belongs_to :asker, :polymorphic => true
  has_many :choices, :dependent => :destroy
  has_many :answers, :dependent => :destroy

  acts_as_list :scope=>:asker

  if respond_to? :attr_accessible # Rails 3.2 backwards compatibility
    attr_accessible :type, :name, :instructions, :required, :choices_attributes, :position
  end
  accepts_nested_attributes_for :choices, :allow_destroy=>true, :reject_if=>lambda{|attrs| attrs['name'].blank? }

  validates_presence_of :type, :name
  validates_inclusion_of :type, :in=>TYPES

  default_scope lambda { order(:position) }
  scope :required, -> { where(:required => true) }

  def attributes_protected_by_default
    default = [ self.class.primary_key ]
    default << 'id' unless self.class.primary_key.eql? 'id'
    default
  end

  # This just means it doesn't expect an answer, such as a form_section question
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

  def supports_uploads?
    false
  end
end
