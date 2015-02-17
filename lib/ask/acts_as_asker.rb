class ActiveRecord::Base
  def self.acts_as_asker
    has_many :questions, :as => :asker, :dependent => :destroy

    if respond_to? :attr_accessible # Rails 3.2 backwards compatibility
      attr_accessible :questions_attributes
    end
    accepts_nested_attributes_for :questions, :allow_destroy=>true, :reject_if=>lambda{|attrs| attrs['name'].blank? }
  end
end
