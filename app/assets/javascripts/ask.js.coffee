jQuery ->
  ### 
    Handle adding and removing fields 
  ###
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    new_question = $($(this).data('fields').replace(regexp, time))
    $(this).before(new_question)
    createQuestionPreview new_question
    toggleEditMode new_question
    event.preventDefault()

  ### 
    Update the edit preview mode between textQuestion, ChecklistQuestion, etc.
  ###
  updateChoiceVisibility = (select) ->
    question = select.parents("fieldset.question")
    question_choices = question.find(".edit-question-choices")
    question_choices.find(".question-type").hide()  # first hide all the question types
    current_question_type = question_choices.find(".question-type."+select.val())
    current_question_type.show()  # Then show the current question type
    question.find('.required-option').show()  # show the required-option field, it may be hidden later by certain question types
    if select.val() == 'ChooseOneQuestion'
      current_question_type.removeClass('show-checkbox').addClass('show-radio')
    else if select.val() == 'ChecklistQuestion'
      current_question_type.removeClass('show-radio').addClass('show-checkbox')
    else if select.val() == 'FormSection'
      question.find('.required-option').hide()
  
  # Update preview type whenever the user changes the type of this question
  $('form').on "change", ".select-question-type select", ->
    updateChoiceVisibility $(this)
  
  bindTypeChange = (select) ->

  # Update once when the DOM first loads
  selects = $(".select-question-type select")
  bindTypeChange selects
  selects.each ->
    updateChoiceVisibility $(this)


  ### 
    Make the list sortable 
  ###
  makeSortable = ->
    questions = $("form .ask.questions")
    questions.sortable
      axis: "y"
      stop: (event, ui) ->
        order = 1
        questions.find(".position-wrapper").each ->
          $(this).find("input").val order
          order++
  makeSortable()


  ###
    Toggle between 'edit' question and 'preview' question
  ###
  createQuestionPreview = (question) ->
    if question.children('.preview-question-fields').length == 0 # if we don't have a question preview yet
      question_type = question.find('.select-question-type select').val() # get question type
      question_details = question.serializeObject(/^.*?\[\d+\]/)  # get question details and choices

      preview_section = $("<div class='preview-question-fields'></div>") # create DOM object
      question.append preview_section
      q_label = $("<label class='preview-question-name'>"+question_details.name+"</label>")
      q_label.addClass("required") if question_details.required == "1"
      q_help_text = if (question_details.instructions != "") then $("<p class='help-block'>"+question_details.instructions+"</p>") else false

      # generate preview based on question type
      switch question_type
        when "TextQuestion"
          preview_section.append(q_label).append("<input type='text'>")
          preview_section.append(q_help_text) if q_help_text
        when "EssayQuestion"
          preview_section.append(q_label).append("<textarea></textarea>")
          preview_section.append(q_help_text) if q_help_text
        when "ChooseOneQuestion"
          preview_section.append(q_label)
          preview_section.append(q_help_text) if q_help_text
          $.each question_details.choices_attributes, (k,v) ->
            unless v._destroy == "1"
              checkbox_item = $("<div class='checkbox-preview-item'></div>")
              checkbox_item.append("<input type='radio'>")
              checkbox_item.append("<span>"+v.name+"</span>")
              preview_section.append(checkbox_item)
        when "ChecklistQuestion"
          preview_section.append(q_label)
          preview_section.append(q_help_text) if q_help_text
          $.each question_details.choices_attributes, (k,v) ->
            unless v._destroy == "1"
              checkbox_item = $("<div class='checkbox-preview-item'></div>")
              checkbox_item.append("<input type='checkbox'>")
              checkbox_item.append("<span>"+v.name+"</span>")
              preview_section.append(checkbox_item)
        when "FormSection"
          preview_section.append("<h3>"+question_details.name+"</h3>")
          preview_section.append(q_help_text) if q_help_text
          preview_section.append("<hr/>")

  toggleEditMode = (question) ->
    if question.hasClass('preview')
      $('fieldset.question.edit').each ->  # first put all other questions into preview mode.
        toggleEditMode($(this))
      question.find('.preview-question-fields').remove()
      question.find('.edit-question-link').html('Done')
      question.removeClass('preview').addClass('edit')

    else if question.hasClass('edit')
      createQuestionPreview(question)
      question.find('.edit-question-link').html('Edit')
      question.removeClass('edit').addClass('preview')


  $('fieldset.question').each ->
    createQuestionPreview $(this)

  $('form').on "click", "a.edit-question-link", (e) ->
    toggleEditMode($(this).closest('fieldset.question'))
    e.preventDefault()


jQuery.fn.serializeObject = (ignore_regex = null) ->
  arrayData = @.find("*").serializeArray()
  objectData = {}

  pushData = (node, hash_tail, value) ->
    hash = hash_tail.shift()
    if hash_tail.length == 0
      node[hash] = value
    else
      unless node[hash]?
        node[hash] = {}
      pushData(node[hash], hash_tail, value)

  $.each arrayData, ->
    if @value?
      value = @value
    else
      value = ''

    # splits nested hash into array of keys
    #  @name needs to be in the form of person[attributes][about][name]
    #  It can also ignore a regular expression
    hash_array = @name.replace(ignore_regex, "").match(/\w+/g)

    # recursive function that builds a nested object based on the name
    pushData(objectData, hash_array, value)

  return objectData