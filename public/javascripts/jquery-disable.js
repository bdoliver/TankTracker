// Enable/disable a widget
 $.fn.disable = function(){
   if (!this.attr('disabled')) return this.attr('disabled','disabled').attr('readonly','readonly').addClass('disabled');
   return this;
 };
 $.fn.enable = function(){
   if (this.attr('disabled')) return this.removeClass('disabled').removeAttr('readonly').removeAttr('disabled');
   return this;
 };
 $.expr.filters.disabled = function(elem){
   return !!(elem.disabled === true || $.attr(elem,'disabled'));
 };
 
 

