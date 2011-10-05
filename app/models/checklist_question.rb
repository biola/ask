class ChecklistQuestion < Question

  def supports_choices
    true
  end
  
  def supports_multiple_answers?
    true
  end

end
