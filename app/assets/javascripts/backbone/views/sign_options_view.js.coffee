window.SignUpView = ListingCreate.extend
  template: JST["templates/sign_up"]

  typeCheck: (e) ->
    current_input = ($ ".line.focus input")
    if (!($ ".line.focus").hasClass('text_entered')) && (e.which != 8)
      current_input.parent().addClass('text_entered')

  textCheck: (e) ->
    current_input = ($ ".line.focus input")
    if current_input.val().length == 0
      current_input.parent().removeClass('text_entered')

window.SignInView = ListingCreate.extend
  template: JST["templates/sign_in"]
  events:
    'click .intention_selected' : "showIntentions"
    'click .intention_select li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'focus input' : 'inputFocus'
    'blur input' : 'inputBlur'

  typeCheck: (e) ->
    current_input = ($ ".line.focus input")
    if (!($ ".line.focus").hasClass('text_entered')) && (e.which != 8)
      current_input.parent().addClass('text_entered')

  textCheck: (e) ->
    current_input = ($ ".line.focus input")
    if current_input.val().length == 0
      current_input.parent().removeClass('text_entered')

window.SortOptionsView = Backbone.View.extend
  template: JST["templates/sort_options"]
  className: "sort_options"
  tagName: "ul"
  events:
    "click .sign_up" : "sign_up"
    "click .sign_in" : "sign_in"
    
  initialize: ->
    _.bindAll @, 'render'
  
  sign_up: ->
    ($ '#main_column').addClass('inactive')
    view = new SignUpView
    ($ '#panel_container').html view.render().el

  sign_in: ->
    ($ '#main_column').addClass('inactive')
    view = new SignInView
    ($ '#panel_container').html view.render().el
    
  render: ->
    HTML = @template
    $(@el).html @template
      current_user: oApp.currentUser
    @