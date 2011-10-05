$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'ask/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'ask'
  s.version     = Ask::VERSION
  s.authors     = ['Adam Crownoble']
  s.email       = ['adam@obledesign.com']
  s.homepage    = 'https://github.com/biola/ask'
  s.summary     = 'End-user form creation engine for Rails'
  s.description = "Allow your site's maintainers to easily create forms."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.1.0'
  s.add_dependency 'haml', '>= 3.0.0'
  s.add_dependency 'acts_as_list', '>= 0.1.2'
  s.add_dependency 'rails_autolink', '~>1.0.2'
  s.add_dependency 'jquery-rails'

  s.add_development_dependency 'sqlite3'
end
