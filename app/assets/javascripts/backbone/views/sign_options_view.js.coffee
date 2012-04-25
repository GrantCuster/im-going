window.SignOptionsView = Backbone.View.extend
  template: JST["templates/sign_options"]
  className: 'sign_options_header'
  events:
    "click a#signup_link" : "showSignUp"
    "click a#signin_link" : "showSignIn"

  initialize: ->

  showSignUp: (e) ->
    link = e.target
    left_pos = ($ '#main_inner').offset().left
    new_width = ($(window).width() - left_pos) - 100
    ($ ".sign_options a").removeClass('active')
    ($ link).addClass('active')
    sign_options = new SignUpView
    ($ '#overlay').show()
    ($ '#side_column').width(new_width).find(".side_content").show().html sign_options.render().el
    return false

  showSignIn: (e) ->
    link = e.target
    left_pos = ($ '#main_inner').offset().left
    new_width = ($(window).width() - left_pos) - 100
    ($ ".sign_options a").removeClass('active')
    ($ link).addClass('active')
    sign_options = new SignInView
    ($ '#overlay').show()
    ($ '#side_column').width(new_width).find(".side_content").show().html sign_options.render().el
    return false

  render: ->
    $(@el).html @template
      current_user: oApp.currentUser.email
    @

window.SignUpView = Backbone.View.extend
  template: JST["templates/sign_up"]
  
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

window.SignInView = Backbone.View.extend
  template: JST["templates/sign_in"]

  events:
    "blur .line input" : "blurInput"
    "focus .line input" : "focusInput"
    "click .line label" : "placeholderPass"
    "keydown .line input" : "typeCheck"
    "keyup .line input" : "textCheck"

  initialize: ->
    _.bindAll @, 'render'

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
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
    $(@el).html HTML
    @