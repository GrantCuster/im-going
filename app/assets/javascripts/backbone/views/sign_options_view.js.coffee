class ImGoing.Views.SignOptionsView extends Backbone.View
  template: JST["backbone/templates/sign_options"]
  events:
    "click a#signup_link" : "showSignUp"
    "click a#signin_link" : "showSignIn"

  initialize: ->
    ($ '.arrow_container').click ->
      ($ 'nav').removeClass 'expanded'
      ($ '.sign_options a').removeClass('active')

  showSignUp: (e) ->
    link = e.target
    ($ ".sign_options a").removeClass('active')
    ($ link).addClass('active')
    sign_options = new ImGoing.Views.SignUpView
    ($ 'nav').addClass('expanded').find(".form_holder").html sign_options.render().el
    return false

  showSignIn: (e) ->
    link = e.target
    ($ ".sign_options a").removeClass('active')
    ($ link).addClass('active')
    sign_options = new ImGoing.Views.SignInView
    ($ 'nav').addClass('expanded').find(".form_holder").html sign_options.render().el
    return false

  render: ->
    $(@el).html(@template)
    @

class ImGoing.Views.SignUpView extends Backbone.View
  template: JST["backbone/templates/sign_up"]
  
  events:
    "blur .line input" : "blurInput"
    "focus .line input" : "focusInput"
    "click .line label" : "placeholderPass"
    "keydown .line input" : "typeCheck"
    "keyup .line input" : "textCheck"
  
  placeholderPass: (e) ->
    target = e.target
    ($ target).parent().find('input').focus()

  blurInput: ->
    ($ '.line').removeClass('focus')
  
  focusInput: (e) ->
    target = e.target
    ($ target).parent().addClass('focus')
  
  typeCheck: (e) ->
    current_input = ($ ".line.focus input")
    if (!($ ".line.focus").hasClass('text_entered')) && (e.which != 8)
      current_input.parent().addClass('text_entered')
  
  textCheck: (e) ->
    current_input = ($ ".line.focus input")
    if current_input.val().length == 0
      current_input.parent().removeClass('text_entered')

  render: ->
    $(@el).html(@template)
    @

class ImGoing.Views.SignInView extends Backbone.View
  template: JST["backbone/templates/sign_in"]

  events:
    "blur .line input" : "blurInput"
    "focus .line input" : "focusInput"
    "click .line label" : "placeholderPass"
    "keydown .line input" : "typeCheck"
    "keyup .line input" : "textCheck"

  placeholderPass: (e) ->
    target = e.target
    ($ target).parent().find('input').focus()

  blurInput: ->
    ($ '.line').removeClass('focus')

  focusInput: (e) ->
    target = e.target
    ($ target).parent().addClass('focus')

  typeCheck: (e) ->
    current_input = ($ ".line.focus input")
    if (!($ ".line.focus").hasClass('text_entered')) && (e.which != 8)
      current_input.parent().addClass('text_entered')

  textCheck: (e) ->
    current_input = ($ ".line.focus input")
    if current_input.val().length == 0
      current_input.parent().removeClass('text_entered')

  render: ->
    $(@el).html(@template)
    @