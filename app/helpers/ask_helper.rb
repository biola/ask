module AskHelper

  def question_label(question, builder=nil)
    if question.type.to_sym == :ChecklistQuestion
      h(question.name)
    else
      if builder
        builder.label(:answer, question.name)
      else
        label_tag(:answer, question.name)
      end
    end
  end

  def question_instructions(question)
    require 'rails_autolink/helpers'
    
    unless question.instructions.blank?
      content_tag(:span, auto_link(simple_format(question.instructions), :all, :target=>'_blank'), :class=>'instructions')
    end || ''
  end

end
