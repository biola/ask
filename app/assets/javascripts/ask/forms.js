$(document).ready(function() 
{
    var handleChoiceNesting = function(container) 
    {
        $(container).find('ul.choices').handleNesting({ 
                                                          nameMatch:   /(.*\[)[0-9]+(\].*)/, 
                                                          nameReplace: '$1{NEW_ID}$2',
                                                          afterAdd:    function(added)
                                                                       {
                                                                           insertDeleteButtons(added.parent(), ".choice");
                                                                       }
                                                      });
    }
  
    var updateChoiceVisibility = function(select)
    {
        if (select.val() == "ChooseOneQuestion" || select.val() == "ChecklistQuestion")
            select.parents("dl").find("dd.choices:hidden").slideDown("fast");
        else
            select.parents("dl").find("dd.choices:visible").slideUp("fast");
    }
    
    var bindTypeChange = function(select)
    {
        select.change(function()
        {
            updateChoiceVisibility($(this));
        });
    }

    var insertDeleteButtons = function(container, selector)
    {
        container.find(selector).each(function()
        {
            // Add a delete button if there isn't one already
            if ($(this).children("button.remove").length == 0)
            {
                $("<button type=\"button\" class=\"remove\">Remove</button>").click(function()
                {
                    $(this).parents(selector).fadeOut("fast", function() 
                    { 
                        $(this).remove(); 
                        // If there's only one option left, remove the delete button
                        if (container.find(selector).length == 1)
                            container.find("button.remove:last").remove();
                    });
            
                    return false;
                }).appendTo($(this));
            }
        });
    }

    var makeSortable = function()
    {
        var questions = $("form ul.ask.questions");
        questions.sortable(
        {
            stop: function(event, ui) 
                  {
                      var order = 1;
                      questions.find(".position-wrapper").each(function()
                      {
                          $(this).find("input").val(order);
                          order ++;
                      });
                  }
        });
    }

    var selects = $("dd.type > select");
    
    bindTypeChange(selects);
    
    selects.each(function()
    {
        updateChoiceVisibility($(this));
    });
    
    makeSortable();
  
    if(jQuery.fn.handleNesting) 
    {
        $('form ul.ask.questions').handleNesting({
                                                 afterAdd: function(added) 
                                                           {
                                                               handleChoiceNesting(added);
                                                               insertDeleteButtons(added.parent(), ".question");
                                                               bindTypeChange(added.find("dd.type > select"));
                                                               makeSortable();
                                                           }
                                             });
    }

    $('form ul.ask.questions').children('li').each(function(i,li) 
    {
        handleChoiceNesting(li);
    });
  
});
