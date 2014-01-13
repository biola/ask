Ask
===
Ask is a Rails engine that provides tools to simplify the process of letting your app's users build forms for things like questionnaires or surveys.

Requirements
------------
- Rails 3.1 or higher
- jQuery
- jQuery UI
- Uses Carrierwave for uploads

More information will be on the [wiki](https://github.com/biola/ask/wiki).


Installation
------------
Add to your Gemfile:

    gem 'ask'

In your terminal run:

    bundle
    rake ask_engine:install:migrations
    rake db:migrate

Usage
-----
Ask needs to be tied to two models in your application: an "asker" and an "answerer". The asker model should be the model that has questions, such as a Survey or Event. The answerer model should be the model that has answers to the questions such as a SurveySubmission or an EventRegistration.

In your asker model add:

    acts_as_asker

In your answerer model add:

    acts_as_answerer

In your asker form views, inside an already defined `form_for` helper add:

    <%= render(:partial => 'asker/form', :locals => { :f => f }) %>

In your answerer form views, inside an already defined `form_for` helper add:

    <%= render(:partial => 'answerer/form', :locals => { :f => f }) %>

In your javascript manifest file add:

    //= require ask

In your stylesheet manifest file add:

    /*  
    *= require ask  
    */

If you want your form to start with one question, you can do the following...
In your asker controller's `new` and `edit` methods you'll need to build the first question and choice. The best way to do this is create a private method:

    def build_questions
      @event.questions.build
      @event.questions.each{|q| q.choices.build}
    end

Then at the top of your asker controller, include:

    before_filter :build_questions, :only => [:new, :edit]
    # or you can call the build_questions method inside the new or edit controller

In your answerer controller's `new` and `edit` methods you'll need to call `build_or_create_answers` and pass it in the appropriate questions. Such as:

    @event_registration.build_or_create_answers @event_registration.event.questions


Finally you'll need to define an `asker` method on your answerer model, like so:

    class EventRegistration < ActiveRecord::Base
      def asker  
        return event  
      end
    end


Configuration
-------------
If you want to changed the default whitelisted file types for upload questions, just drop this into an initializer file.

    Ask.configure do |config|
      @upload_whitelist = %w(jpg jpeg gif png doc docx txt pdf xls xlsx zip)
    end


Build Status
------------
[![Build Status](https://travis-ci.org/biola/ask.png)](https://travis-ci.org/biola/ask)


License
-------
MIT License
