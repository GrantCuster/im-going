window.ShareView = Backbone.View.extend
  template: JST["templates/share"]
  className: "share group"
  events: 
    "focus textarea" : "active"
    "blur textarea" : "inactive"
    "click .post" : "share"
    "click .cancel" : "cancel"

  initialize: (options) ->
    @service = options.service
    @listing = options.listing
    _.bindAll @, 'render'

  cancel: ->
    ($ @el).remove()

  active: ->
    ($ @el).find('textarea').addClass 'active'
    ($ @el).find('.post').addClass 'active'

  inactive: ->
    if ($ @el).find('textarea').val().length == 0
      ($ @el).find('textarea').removeClass 'active'
      ($ @el).find('.post').removeClass 'active'
  
  share: (e) ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    message = ($ @el).find('textarea').text()
    if ($ e.target).hasClass 'twitter'
      $.post('/share/twitter', { client: "twitter", authenticity_token: token, message: message }, (data) =>
        ($ @el).html '<div class="success">posted to twitter</div>'
      )
    else
      $.post('/share/facebook', { client: "facebook", authenticity_token: token, message: message }, (data) =>
        ($ @el).html '<div class="success">posted to facebook</div>'
      )        

  render: ->
    HTML = @template
    ($ @el).html HTML
      service: @service
      message: @listing.getSnippet()
    @