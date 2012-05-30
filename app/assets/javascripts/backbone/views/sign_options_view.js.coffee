window.SignUpView = ListingCreate.extend
  template: JST["templates/sign_up"]

  initialize: (collection) ->
    _.bindAll @
    if ($ '.text_container').length == 0
      ($ 'body').append '<div class="text_container"><div class="text_clone"></div></div>'

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

  initialize: (collection) ->
    _.bindAll @
    if ($ '.text_container').length == 0
      ($ 'body').append '<div class="text_container"><div class="text_clone"></div></div>'

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
    
  initialize: ->
    _.bindAll @, 'render'
    
  render: ->
    HTML = @template
    $(@el).html @template
      current_user: oApp.currentUser
    @

window.SignOptionsView = Backbone.View.extend
  template: JST["templates/sign_options"]
  className: "sign_up_options"
  tagName: "ul"
  events:
    "click .facebook_target" : "sign_up"
    "click .twitter_target" : "sign_in"
    "mouseenter .facebook_target" : "facebookEnter"
    "mouseleave .facebook_target" : "facebookLeave"
    "mouseenter .twitter_target" : "twitterEnter"
    "mouseleave .twitter_target" : "twitterLeave"
  
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

  facebookEnter: ->
    ($ '.sign_up_options').addClass 'facebooked'
  
  facebookLeave: ->
    ($ '.sign_up_options').removeClass 'facebooked'

  twitterEnter: ->
    ($ '.sign_up_options').addClass 'twittered'

  twitterLeave: ->
    ($ '.sign_up_options').removeClass 'twittered'

  render: ->
    HTML = @template
    $(@el).html @template
      current_user: oApp.currentUser
    @