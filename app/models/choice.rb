class Choice < ActiveRecord::Base
  if respond_to? :attr_accessible # Rails 3.2 backwards compatibility
    attr_accessible :name
  end

  belongs_to :question
end
