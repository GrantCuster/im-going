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
  # ($ '#overlay').click ->
  #   ($ '.form_holder').hide()
  #   ($ '#overlay').hide()
  #   ($ ".sign_options a").removeClass('active')
  #   ($ '#side_column').width(180)
  #   ($ '.listing_create_container').hide()
  #   return false
  
Backbone.Model.prototype.toJSON = ->
  return _(_.clone(this.attributes)).extend
    'authenticity_token' : $('meta[name="csrf-token"]').attr('content')