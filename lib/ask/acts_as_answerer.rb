module Ask
  module ActiveRecord
    
    module InstanceMethods
      def all_questions
        if respond_to? :asker
          @all_questions ||= asker.questions
        else
          raise NoMethodError, "You must define a #{self}#asker method that returns the related acts_as_asker model"
        end
      end
    
      def find_question(question)
        if question.is_a? Question
          question
        elsif question.is_a? Fixnum
          all_questions.find_by_id(question)
        else
          all_questions.find_by_name(question.to_s)
        end
      end

      def questions_by_section
        section = nil
        questions = {}
        
        asker.questions.order(:position).each do |question|
          if question.is_a? FormSection
            section = question
          end
          
          questions[section] ||= []
          
          unless question.is_a? FormSection
            questions[section] << question
          end
        end
        
        questions
      end

      def answer_to(question)
        return nil if question.nil?
        if question.supports_multiple_answers?
          answers_to(question)
        else
          answers.find_by_question_id(question.id)
        end
      end

      def answers_to(question)
        return nil if question.nil?
        answers.for_question(question)
      end
      
      def build_or_create_answers(questions)
        method = new_record? ? :build : :create
        
        questions.each do |question|
          if answers_to(question).empty?
          
            if question.supports_multiple_answers?
              question.choices.each do |choice|
                answers.send(method, :question_id=>question.id, :answer=>'', :choice_id=>choice.id)
              end
            else
              answers.send(method, :question_id=>question.id)
            end
            
          end
        end
      end
      
      def questions_with_answers
        qa = ActiveSupport::OrderedHash.new
        
        # Set the correct order and make sure we have all the questions
        all_questions.each do |q|
          qa[q.name] = []
        end
        
        answers.each do |a|
          qa[a.question.name] << a.answer.to_s.strip unless a.answer.blank?
        end
        
        qa
      end
      
      private
      
      def validate_required_questions
        asker.questions.required.each do |question|
          if answers.select{|a| a.question_id == question.id}.all?{|a| a.answer.blank?}
            errors[:base] << "\"#{question.name}\" is required"
          end
        end
      end
    end
    
  end
end

class ActiveRecord::Base
  def self.acts_as_answerer
    include Ask::ActiveRecord::InstanceMethods
    
    has_many :answers, :as => :answerer, :dependent=>:destroy
    has_many :questions, :through=>:answers
    
    attr_accessible :answers_attributes
    accepts_nested_attributes_for :answers, :allow_destroy=>true
    
    validate :validate_required_questions
  end
end
