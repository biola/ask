module AskHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("asker/"+association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

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
