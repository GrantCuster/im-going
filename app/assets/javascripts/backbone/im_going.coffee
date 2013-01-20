#= require_self
#= require_tree ../templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.ImGoing =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    window.router = new ApplicationRouter()
    Backbone.history.start({pushState: true})

$(document).ready ->
  ImGoing.init()
  # fix to get autocomplete working on contenteditable
  `(function ($) {
   var original = $.fn.val;
   console.log('it ran');
   $.fn.val = function() {
      if ($(this).is('[contenteditable]')) {
         return $.fn.text.apply(this, arguments);
      };
      return original.apply(this, arguments);
   };
  })(jQuery);`

Backbone.Model.prototype.toJSON = ->
  return _(_.clone(this.attributes)).extend
    'authenticity_token' : $('meta[name="csrf-token"]').attr('content')