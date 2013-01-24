window.SignUpView = ListingCreate.extend
  template: JST["templates/sign_up"]

  initialize: (collection) ->
    _.bindAll @

window.SignInView = ListingCreate.extend
  template: JST["templates/sign_in"]
  events:
    'click .intention_selected' : "showIntentions"
    'click .intention_select li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'focus .input' : 'inputFocus'
    'blur .input' : 'inputBlur'

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

window.UserEditView = ListingCreate.extend
  template: JST["templates/users/edit_user"]
  events:
    'click .modal_close' : 'closeModal'
    'focus .input' : 'inputFocus'
    'blur .input' : 'inputBlur'
    'click input[type="submit"]' : "save"
    'click .new_share' : 'connect'

  initialize: () ->
    _.bindAll @

  connect: (e) ->
    if ($ e.target).hasClass 'twitter'
      if ($ e.target).hasClass 'share_it'
        ($ e.target).removeClass 'share_it'
        data = {}
        data["tw_id"] = null
        data["tw_token"] = null
        data["tw_secret"] = null
        @model.save data
      else
        window.location = '/users/auth/twitter'
    else
      if ($ e.target).hasClass 'share_it'
        ($ e.target).removeClass 'share_it'
        data = {}
        data["fb_id"] = null
        data["fb_token"] = null
        @model.save data
      else
        window.location = '/users/auth/facebook'

  inputBlur: (e) ->
    input = ($ e.target)
    if input.text().length > 0
      characters = input.text()
      if ($ e.target).attr('id') == "user_email"
        ($ e.target).removeClass 'invalid'
        ($ 'input[type="submit"]').removeClass 'not_ready'
    else
      # fix for breaks being inserted
      input.html('')

  save: () ->
    old_username = @model.getName()
    username = ($ @el).find('#user_username').text().trim()
    email = ($ @el).find('user_email').text().trim()
    description = ($ @el).find('#user_description').text().trim()
    data = {}
    data["username"] = username
    data["email"] = email
    data["description"] = description
    @model.save data
    ($ '#main_column').removeClass('inactive')
    ($ '#panel_container').html ""
    if username != old_username
      window.location = "/#{username}"
    return false

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
      name: @model.getName()
      email: oApp.currentUser.email
      imageURL: @model.getImageURL()
      description: @model.getDescription()
      fb_connect: true if oApp.currentUser && oApp.currentUser.fb_token
      tw_connect: true if oApp.currentUser && oApp.currentUser.tw_token
      current_user_id: if oApp.currentUser then oApp.currentUser.id else false
    ($ @el).html(HTML)
    @

window.UserNewView = ListingCreate.extend
  template: JST["templates/users/new_user"]
  events:
    'click .modal_close' : 'closeModal'
    'focus .input' : 'inputFocus'
    'blur .input' : 'inputBlur'
    'click input[type="submit"]' : 'createUser'

  initialize: () ->
    _.bindAll @

  inputBlur: (e) ->
    input = ($ e.target)
    if input.text().length > 0
      characters = input.text()
      if ($ e.target).attr('id') == "user_email"
        ($ e.target).removeClass 'invalid'
        ($ 'input[type="submit"]').removeClass 'not_ready'
    else
      # fix for breaks being inserted
      input.html('')

  createUser: (e) ->
    if ($ e.target).hasClass 'not_ready'
      return false
    else
      me = @
      username = $('#user_username').val()
      email = $('#user_email').val()
      description = $('#user_description').val()
      data = {}
      data["username"] = username
      data["email"] = email
      data["description"] = description
      console.log 'here at least'
      @model.save data, success: (data) ->
        window.location.href = '/'
    return false

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
      name: @model.getName()
      email: oApp.currentUser.email
      imageURL: @model.getImageURL()
      description: @model.getDescription()
    ($ @el).html(HTML)
    @

window.SortOptionsView = Backbone.View.extend
  template: JST["templates/sort_options"]
  className: "sort_options"
  tagName: "ul"
  events:
    'click #sort_nyc' : 'NYC'
    'click #sort_friends' : 'friends'
    'click #sort_you' : 'you'
    
  initialize: (options) ->
    @options = options || ""
    _.bindAll @, 'render'
  
  NYC: (e) ->
    unless window.location.pathname == "/nyc"
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate '/nyc', {trigger: true}
      , 100
  
  friends: (e) ->
    ($ @el).find('li').removeClass 'active'
    ($ e.target).addClass 'active'
    unless window.location.pathname == "/friends"    
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate '/friends', {trigger: true}
      , 100
  
  you: (e) ->
    username = oApp.currentUser.username
    unless window.location.pathname == "/#{username}"    
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate "/#{username}", {trigger: true}
      , 100
    
  render: () ->
    HTML = @template
    $(@el).html @template
      current_user: oApp.currentUser
      nyc: true if @options.active == "nyc"
      friends: true if @options.active == "friends"
      you: true if @options.active == "you"
    @

window.SignOptionsView = Backbone.View.extend
  template: JST["templates/sign_options"]
  className: "sign_up_options"
  tagName: "ul"
  events:
    "click .facebook_target" : "facebook"
    "click .twitter_target" : "twitter"
    "mouseenter .facebook_target" : "facebookEnter"
    "mouseleave .facebook_target" : "facebookLeave"
    "mouseenter .twitter_target" : "twitterEnter"
    "mouseleave .twitter_target" : "twitterLeave"
  
  initialize: ->
    _.bindAll @, 'render'

  twitter: ->
    window.open '/auth/twitter'

  facebook: ->
    window.open '/auth/facebook'

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