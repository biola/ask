Ask
===
Ask is a Rails engine that provides tools to simplify the process of letting your app's users build forms for things like questionnaires or surveys.

Requirements
------------
- Rails 3.1 or higher

Installation
------------
Add to your Gemfile:

    gem 'ask'

In your terminal run:

    bundle

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

In your answerer controller's `new` and `edit` methods you'll want to call `build_or_create_answers` and pass it in the appropriate questions. Such as:

    @event_registration.build_or_create_answers @event_registration.event.questions


Finally you'll need to define an `asker` method on your answerer model, like so:

    class EventRegistration < ActiveRecord::Base
      def asker  
        return event  
      end
    end

License
-------
MIT License
