(function($){
  $.HandleNesting = function(el, options){
    // To avoid scope issues, use 'base' instead of 'this'
    // to reference this class from internal events and functions.
    var base = this;
    
    // Access to jQuery and DOM versions of element
    base.$el = $(el);
    base.el = el;
    base.items = [];
    base.blank = null;
    
    // Add a reverse reference to the DOM object
    base.$el.data("HandleNesting", base);
    
    base.init = function(){

      base.options = $.extend({},$.HandleNesting.defaultOptions, options);
      
      base.items = base.$el.children('li');
      if(base.items.length) {
        base.blank = $(base.items[base.items.length-1]).clone();
      }
      
      base.addButtons();
        
    };
    
    base.addButtons = function() {
      base.addAddButton();
      base.items.each(function(i,item) { base.addRemoveButton(item); })
    };
    
    base.addAddButton = function() {
      var addButton = $('<button type="button"/>').addClass('add').text('Add');
      addButton.click(function() { base.add(); });
      base.$el.after(addButton);
    }
    
    base.addRemoveButton = function(item) {
    
      var destroys = $(item).find('input[name*=_destroy]')
      
      destroys.each(function(i,destroy) {
      
        if($(item).find('button.remove').length == 0) {
          var removeButton = $('<button type="button"/>').addClass('remove').text('Remove');
          removeButton.click(function() { base.remove(this); });
          $(item).append(removeButton);
        }
          
        $(destroy).hide();
        $(item).find('label[for='+$(destroy).attr('id')+']').hide();
        
      });
    }
    
    base.add = function() {

      var newId = new Date().getTime();
      var match = base.options.nameMatch;
      var replace = base.options.nameReplace.replace(/{NEW_ID}/g, newId);
      
      if(base.options.beforeAdd != null) {
        base.options.beforeAdd();
      }
    
      var added = base.blank.clone().hide();

      added.find('*').each(function(i, el) {
        $(el).attr('id', null);
      });

      added.find('input, select, textarea').each(function(i, el) {
        $(el).val('');
        el.name = el.name.replace(match, replace);
      });
    
      base.$el.append(added);
    
      if(base.options.afterAdd != null) {
        base.options.afterAdd(added);
      }
      
      added.fadeIn("fast");
    
    }
    
    base.remove = function(item) {
      var li = $(item).closest('li');
      li.find('input[name*=_destroy]').val(1);
      li.find('input:checkbox[name*=_destroy]').attr('checked', 'checked');
      li.fadeOut("fast");//, function() { $(this).remove() });
    }
    
    // Run initializer
    base.init();
  };
  
  $.HandleNesting.defaultOptions = {
    nameMatch: /\[[0-9]+\]/,
    nameReplace: '[{NEW_ID}]',
    beforeAdd: null,
    afterAdd: null
  };
  
  $.fn.handleNesting = function(options){
    return this.each(function(){
      (new $.HandleNesting(this, options));
    });
  };
    
})(jQuery);
