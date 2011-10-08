#= require jquery.handle-nesting

$(document).ready ->
  handleChoiceNesting = (container) ->
    $(container).find("ul.choices").handleNesting 
      nameMatch: /(.*\[)[0-9]+(\].*)/
      nameReplace: "$1{NEW_ID}$2"
      afterAdd: (added) ->
        insertDeleteButtons added.parent(), ".choice"
  
  updateChoiceVisibility = (select) ->
    if select.val() == "ChooseOneQuestion" or select.val() == "ChecklistQuestion"
      select.parents("dl").find("dd.choices:hidden").slideDown "fast"
    else
      select.parents("dl").find("dd.choices:visible").slideUp "fast"
  
  bindTypeChange = (select) ->
    select.change ->
      updateChoiceVisibility $(this)
  
  insertDeleteButtons = (container, selector) ->
    container.find(selector).each ->
      if $(this).children("button.remove").length == 0
        $("<button type=\"button\" class=\"remove\">Remove</button>").click(->
          $(this).parents(selector).fadeOut "fast", ->
            $(this).remove()
            container.find("button.remove:last").remove()  if container.find(selector).length == 1
          
          false
        ).appendTo $(this)
  
  makeSortable = ->
    questions = $("form ul.ask.questions")
    questions.sortable stop: (event, ui) ->
      order = 1
      questions.find(".position-wrapper").each ->
        $(this).find("input").val order
        order++
  
  selects = $("dd.type > select")
  bindTypeChange selects
  selects.each ->
    updateChoiceVisibility $(this)
  
  makeSortable()
  if jQuery.fn.handleNesting
    $("form ul.ask.questions").handleNesting afterAdd: (added) ->
      handleChoiceNesting added
      insertDeleteButtons added.parent(), ".question"
      bindTypeChange added.find("dd.type > select")
      makeSortable()
  
  $("form ul.ask.questions").children("li").each (i, li) ->
    handleChoiceNesting li
