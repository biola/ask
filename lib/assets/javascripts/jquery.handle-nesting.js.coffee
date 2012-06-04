(($) ->
  $.HandleNesting = (el, options) ->
    base = this
    base.$el = $(el)
    base.el = el
    base.items = []
    base.blank = null
    base.$el.data "HandleNesting", base
    base.init = ->
      base.options = $.extend({}, $.HandleNesting.defaultOptions, options)
      base.items = base.$el.children("li")
      base.blank = $(base.items[base.items.length - 1]).clone()  if base.items.length
      base.addButtons()
    
    base.addButtons = ->
      base.addAddButton()
      base.items.each (i, item) ->
        base.addRemoveButton item
    
    base.addAddButton = ->
      addButton = $("<button type=\"button\"/>").addClass("add").text("Add")
      addButton.click ->
        base.add()
      
      base.$el.after addButton
    
    base.addRemoveButton = (item) ->
      destroys = $(item).find("input[name*=_destroy]")
      destroys.each (i, destroy) ->
        if $(item).find("button.remove").length == 0
          removeButton = $("<button type=\"button\"/>").addClass("remove").text("Remove")
          removeButton.click ->
            base.remove this
          
          $(item).append removeButton
        $(destroy).hide()
        $(item).find("label[for=" + $(destroy).attr("id") + "]").hide()
    
    base.add = ->
      newId = new Date().getTime()
      match = base.options.nameMatch
      replace = base.options.nameReplace.replace(/{NEW_ID}/g, newId)
      base.options.beforeAdd()  if base.options.beforeAdd?
      added = base.blank.clone().hide()
      added.find("*").each (i, el) ->
        $(el).attr "id", null
      
      added.find("input, select, textarea").each (i, el) ->
        $(el).val ""
        el.name = el.name.replace(match, replace)
        
      base.addRemoveButton added
      
      base.$el.append added
      base.options.afterAdd added  if base.options.afterAdd?
      added.fadeIn "fast"
      
      # Temporary hack to fix the bug where choices don't 
      #    display if you go back to edit the form and the 
      #    last question was a choose one question.
      added.find("dd.choices").css "height", "auto"
      added.find("dd.choices").hide()
      # Remove any extra choices field and just leave the first one
      firstchoice = added.find("ul.choices").children().first()
      added.find("ul.choices").html firstchoice
    
    base.remove = (item) ->
      li = $(item).closest("li")
      li.find("input[name*=_destroy]").val 1
      li.find("input:checkbox[name*=_destroy]").attr "checked", "checked"
      li.fadeOut "fast"
    
    base.init()
  
  $.HandleNesting.defaultOptions = 
    nameMatch: /\[[0-9]+\]/
    nameReplace: "[{NEW_ID}]"
    beforeAdd: null
    afterAdd: null
  
  $.fn.handleNesting = (options) ->
    @each ->
      new $.HandleNesting(this, options)
) jQuery
