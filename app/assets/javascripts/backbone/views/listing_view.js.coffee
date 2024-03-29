window.ListingView = Backbone.View.extend
  template: JST["templates/listings/listing"]
  className: "listing group"
  events: 
    "click .name" : 'listingToggle'
    "click .going a" : "userLoad"
    "click .go_options li" : "intentionChoice"
    "click .edit" : "editListing"
    "click .delete" : "deleteListing"
    "click .map_link" : "showMap"
    "click .permalink" : "loadPermalink"
    "click a.intenter" : "intenterFalse"
    "click a.share" : "intenterFalse"
    "click .comment_show" : "showComments"
    "click .share_twitter" : "share"
    "click .share_facebook" : "share"
    "click .permalink" : "permalink"

  initialize: (options) ->
    _.bindAll @, 'render'
    me = @
    if options.permalink == true
      ($ @el).addClass 'expanded'
      @permalink_page = true
    @model.bind 'change', @render, @

  initSubViews: ->
    comments = new Comments @model.getComments()
    view = new CommentsView collection: comments, listing: @model
    ($ @el).find('.comment_container').html view.render().el

  listingToggle: ->
    unless @permalink == true
      if ($ @el).hasClass('expanded')
        ($ @el).find('.main_bottom_container').slideUp 100, =>
          ($ @el).removeClass('expanded')
      else
        ($ @el).find('.main_bottom_container').slideDown 100, =>
          ($ @el).addClass('expanded')

  userLoad: (e) ->
    username = ($ e.target).attr('href')
    unless window.location.pathname == "#{username}"
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate username, {trigger: true}
      , 100
    return false
  
  loadPermalink: ->
    id = @model.getID()
    listing = "/listings/#{id}"
    unless window.location.pathname == "listings/#{id}"
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        window.router.navigate listing, {trigger: true}
      , 100
    return false

  showComments: (e) ->
    ($ @el).find('.comment_container').addClass('show').find('textarea').focus()
    ($ e.target).hide()
    return false

  showMap: (e) ->
    e.stopPropagation()
    if ($ e.target).hasClass 'open'
      ($ e.target).removeClass 'open'
      ($ @el).find('.listing_map').removeClass 'show'
    else
      ($ e.target).addClass 'open'
      ($ @el).find('.listing_map').addClass 'show'
      unless ($ @el).find('.listing_map div').length > 0
        $el = ($ @el).find('.listing_map')
        lat = @model.getLat()
        lng = @model.getLng()
        map = new GMaps
          div: $el,
          lat: lat,
          lng: lng
        map.addMarker
          lat: lat,
          lng: lng    
  
  share: (e) ->
    if ($ e.target).hasClass 'not_connected'
      window.location = '/users/auth/twitter'
    else
      if ($ e.target).hasClass 'share_twitter'
        view = new ShareView listing: @model, service: "twitter"
      $share_container = ($ @el).find('.share_container')
      $share_container.html(view.render().el)
      value = $share_container.find('textarea').text()
      $share_container.find('textarea').focus().text(value)
      ($ @el).find('.share_option').addClass 'click'
      setTimeout =>
        ($ @el).find('.share_option').removeClass 'click'
      , 50
  
  editListing: ->
    ($ @el).addClass 'editing'
    view = new ListingEdit model: @model
    ($ '#panel_container').html view.render().el
    ($ '#main_column').addClass 'inactive'
    return false
  
  deleteListing: ->
    ($ @el).addClass 'editing'
    @model.destroy
      success: (model, response) =>
        ($ @el).slideUp 200, =>
          ($ @el).remove()
    return false
  
  intenterFalse: ->
    return false
  
  permalink: ->
    ($ '#wrapper').addClass 'transition'
    setTimeout =>
      window.router.navigate "/listings/#{@model.getID()}", {trigger: true}
    , 100
  
  intentionChoice: (e) ->
    if ($ @el).find('.go_options').hasClass 'signed_out'
      if ($ e.target).hasClass 'facebook_sign'
        window.location = '/users/auth/facebook'
      else
        window.location = '/users/auth/twitter'
    else
      ($ @el).find('.intent_option').addClass 'loading'
      @intentions = @model.getIntentions()
      current_intention = false
      @intentions.each (intention) ->
        if intention.getUserID() == oApp.currentUser.id
          current_intention = intention
      @intentions.bind 'add', @render, @
      @intentions.bind 'change', @render, @
      @intentions.bind 'remove', @render, @
      intent = ($ e.target).index() + 1
      listing_id = @model.getID()
      user_id = oApp.currentUser.id
      data = {}
      data["listing_id"] = listing_id
      data["user_id"] = user_id
      data["intention"] = intent
      if current_intention
        if intent == 4
          current_intention.destroy()
          @model.fetch()
        else
          current_intention.save data, success: (date) =>
            @model.fetch()
      else
        @intentions.create data, success: (data) =>
          @model.fetch()
    return false

  render: ->
    user = @model.getUser()
    comment_number = @model.getComments().length
    @intentions = @model.getIntentions()
    if oApp.currentUser.id == @model.getUserID()
      user_listing = true
    else
      user_listing = false
    intented = false
    user_intent = false
    intention_1 = false
    intention_2 = false
    intention_3 = false
    unless user_listing
      @intentions.each (intention) =>
        if intention.getUserID() == oApp.currentUser.id
          intented = true
          user_intent = intention
          intention_num = intention.getIntention()
          if intention_num == 1
            intention_1 = true
          else if intention_num == 2
            intention_2 = true
          else
            intention_3 = true
    HTML = @template
      current_user: oApp.currentUser
      user_listing: user_listing if user_listing == true
      name: @model.getName()
      intented: intented if intented == true
      username: user.username
      user_id: @model.getUserID()
      day: @model.getDay()
      date: @model.getDate()
      time: @model.getTime()
      venue_name: @model.getVenueName()
      venue_address: @model.getVenueAddress()
      venue_url: @model.getVenueUrl()
      venue_map: @model.getIfMap()
      description: @model.getEventDescription()
      urgency: @model.getUrgency()
      ticket_display: true if (@model.getSaleDate() || @model.getCost() || @model.getTicketOption() == 2)
      free: true if @model.getTicketOption() == 2
      sale_date: @model.getSaleDate()
      listing_month: @model.getSaleMonth()
      listing_day: @model.getSaleDay()
      tip_date: @model.getSaleTip()
      urgency_tip: if @model.getUrgency() == "green" then "in more than a week" else if @model.getUrgency() == "orange" then "in less than a week" else if @model.getUrgency() == "red" then "very soon"
      cost: @model.getCost()
      ticket_url: @model.getTicketUrl()
      user_intent: user_intent.getText() if user_intent
      intentions: @intentions.order() if @intentions.length > 0
      intention_1: true if intention_1
      intention_2: true if intention_2
      intention_3: true if intention_3
      listing_id: @model.getID()
      no_comments: true if comment_number == 0
      fb_connected: true if oApp.currentUser && oApp.currentUser.fb_token
      tw_connected: true if oApp.currentUser && oApp.currentUser.tw_token
      permalink_page: true if @permalink_page == true
    ($ @el).html HTML
    @initSubViews()
    ($ @el).attr 'data-id', @model.getID()
    @

window.ListingsView = Backbone.View.extend
  className: "events_listing"
  template: JST["templates/listings/index"]
  
  initialize: ->
    _.bindAll @, 'initSubViews', 'render'
  
  addOne: (listing) ->
    window.side_listings.add listing
    @render()

  initSubViews: ->
    me = @
    me.listing_views = []
    me.month = null
    me.new_month = null
    @collection.each (listing) ->
      me.listing_views.push new ListingView
        model: listing
    _.each(me.listing_views, (listing_view) ->    
      listing_month = listing_view.model.getMonth()
      if me.month != listing_month
        me.month = listing_month
        ($ me.el).append '<div class="month_container"><div class="month">' + listing_month + '</div></div>'
      ($ me.el).append listing_view.render().el
    )
    
  monthScroll: ->
    ($ window).scroll ->
      me = @
      month_conts = ($ '.month_container').get().reverse()
      $(month_conts).each (i) ->
        if (($(this).offset().top - 5) < ($ window).scrollTop())
          if !($ this).find('.month').hasClass 'active'
            ($ this).find('.month').addClass 'active'
        else
          ($ this).find('.month').removeClass 'active'

  render: ->
    me = @
    ($ @el).html @template
    @initSubViews()
    @monthScroll()
    @

window.ListingsHeader = Backbone.View.extend
  template: JST["templates/listings/header"]
  events:
    'click .base' : 'base'
    'click .twitter' : 'twitter'

  initialize: (options) ->
    @options = options || ""
    
  twitter: ->
    window.location = '/users/auth/twitter'

  base: ->
    if window.location.pathname == "/nyc"
      $listings = $('.listing')
      $listings.each ->
        if $(this).hasClass('expanded')
          $(this).removeClass('expanded').find('.main_bottom_container').slideUp(100);
    else
      ($ '#wrapper').addClass 'transition'
      setTimeout =>
        ($ '#main_inner').addClass 'transparent'
        setTimeout =>
          window.router.navigate '/nyc', {trigger: true}
        , 100
      , 100

  render: ->
    me = @
    HTML = @template
      active: @options.active
      current_user: oApp.currentUser
    ($ @el).html HTML        
    @

window.SideListingsView = Backbone.View.extend
  className: "side_listing"
  template: JST["templates/listings/side_listings"]

  initialize: ->
    window.side_listings = @collection
    _.bindAll @, 'initSubViews', 'render'
    @collection.bind 'add', @render, @
    @collection.bind 'remove', @render, @

  initSubViews: ->
    me = @
    me.listing_views = []
    me.month = null
    first_five = @collection.first(5)
    _.each(first_five, (listing) ->
      view = new SideListingView
        model: listing
      ($ me.el).append view.render().el
    )

  render: ->
    me = @
    ($ @el).html @template
    @initSubViews()
    @

window.SideListingView = Backbone.View.extend
  template: JST["templates/listings/side_listing"]
  tagName: "span"
  className: "listing"
  events: 
    'click span' : 'findListing'

  initialize: ->
    _.bindAll @, 'render'
    @model.bind 'change', @render, @

  findListing: ->
    listing_id = ($ @el).find('span').attr("data-id").trim()
    listing_target = ($ '.listing[data-id="' + listing_id + '"]')
    offset = listing_target.offset().top - 40
    ($ 'html, body').animate
      scrollTop: offset
    , 200
    unless listing_target.hasClass('expanded')
      listing_target.addClass('expanded')
      listing_target.find('.main_bottom_container').slideDown(100)

  render: ->
    user = @model.getUser()
    intention_num = @model.getIntention()
    if intention_num == 0
      intention = "is going to"
    else if intention_num == 1
      intention = "is thinking about going to"
    else
      intention = "would go, if somebody else does, to"
    HTML = @template
      username: user.username
      name: @model.getName()
      shortdate: @model.getShortDate()
      listing_id: @model.getID()
      intention: intention
    ($ @el).html HTML
    @

window.BookmarkletCreate = Backbone.View.extend
  className: "panel"
  template: JST["templates/listings/new"]
  events:
    'click input[type="submit"]' : "createListing"
    'click .intention_container' : "showIntentions"
    'click .intention_container li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'click #map_option' : 'removeMap'
    'focus .input' : 'inputFocus'
    'blur .input' : 'inputBlur'
    'click .new_share' : 'toggleShare'
    'mouseenter input[type="submit"]' : 'submitEnter'
  
  initialize: (options) ->
    _.bindAll @

  initializeAutocomplete: ->
    el = $('.listing_create_container')

    $("#listing_day").autocomplete
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getDates()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        matcher_three = new RegExp("\\b" + terms[2], "i") if term_count > 2
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
          else if term_count == 3
            return matcher.test(item) && matcher_two.test(item) && matcher_three.test(item)
        responseFn(a) 
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    $("#listing_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getTimes()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
        responseFn(a) 
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    $("#listing_sale_day").autocomplete
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getDates()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        matcher_three = new RegExp("\\b" + terms[2], "i") if term_count > 2
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
          else if term_count == 3
            return matcher.test(item) && matcher_two.test(item) && matcher_three.test(item)
        responseFn(a)
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none" 
    $("#listing_sale_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getTimes()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
        responseFn(a)
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    ($ '#listing_venue_name').autocomplete
      select: (event, ui) =>
        address = ui.item.attributes.venue_address
        url = ui.item.attributes.venue_url
        if address
          ($ '#listing_venue_address').val address
          @addMap($ '#listing_venue_address')
        if url
          ($ '#listing_venue_url').val url
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"

    @venues = new Venues
    @venues.fetch
      url: "venues.json"
      success: (collection, response) => 
        @venues = collection
        @venue_list = collection.models
        @venue_names = []
        _.each(@venue_list, (venue) =>
          @venue_names.push venue.attributes.venue_name
          venue.label = venue.attributes.venue_name
        )
        ($ '#listing_venue_name').autocomplete("option", "source", @venue_list)

  toggleShare: (e) ->
    ($ e.target).toggleClass 'share_it'

  showIntentions: (e) ->
    if ($ e.target).hasClass('.intention_container')
      $container = ($ e.target)
    else
      $container = ($ e.target).parents('.intention_container')
    $options  = $container.find('.intention_select')
    if $options.hasClass 'active'
      $options.removeClass 'active'
      $container.removeClass 'active'
    else
      $options.addClass 'active'
      $container.addClass 'active'
  
  closeModal: ->
    ($ @el).remove()
    return false

  intentionSelect: (e) ->
    $target = ($ e.target)
    $intention_container = $target.parents('.intention_container')
    $intention_select = $target.parents('.intention_select')
    $intention_selected = $intention_select.prev()
    $intention_selected.removeClass 'virgin'
    new_text = $target.text()
    $intention_container.removeClass('active').find('li').removeClass 'active'
    $target.addClass 'active'
    $intention_selected.html(new_text + '<div class="intention_triangle"></div>').removeClass 'active'
    if ($intention_container.attr('id') == "ticket_option")
      index = $intention_select.find('li').index(e.target)
      if (index == 0)
        ($ '.not_free').removeClass('hidden')
        ($ '.future_sale').addClass('hidden')
      else if (index == 1)
        ($ '.not_free').removeClass('hidden')
        ($ '.future_sale').removeClass('hidden')
      else if (index == 2)
        ($ '.not_free').addClass('hidden')
        ($ '.future_sale').addClass('hidden')
      else
        $intention_selected.addClass 'virgin'
        ($ '.not_free').addClass('hidden')
        ($ '.future_sale').addClass('hidden')
    
  createListing: (e) ->
    me = @
    if ($ e.target).hasClass 'not_ready'
      return false
    else
      me = @
      listing_name = ($ "#listing_listing_name").val()
      selected_day = ($ '#listing_day').val().toString()
      strip_day = selected_day.substr(selected_day.indexOf(" ") + 1)
      full_day = strip_day + " 2013"
      selected_time = ($ '#listing_time').val()
      selected_date = new Date(full_day + " " + selected_time)
      formatted_date = 
        if (selected_day.length > 0)
          $.format.date(selected_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      venue_name = ($ '#listing_venue_name').val()
      venue_address = ($ '#listing_venue_address').val()
      venue_url = ($ '#listing_venue_url').val()
      lat = @map.lat * 1000000 if @map
      lng = @map.lng * 1000000 if @map
      event_description = ($ '#listing_event_description').val()
      intention = ($ '#intention .intention_select').find('li.active').index()
      ticket_option = ($ '#ticket_option .intention_select').find('li.active').index()
      sell_out = ($ '#sell_out .intention_select').find('li.active').index()
      cost = ($ '#listing_cost').val()
      selected_sale_day = ($ '#listing_sale_day').val().toString()
      sale_strip_day = selected_sale_day.substr(selected_sale_day.indexOf(" ") + 1)
      full_sale_day = sale_strip_day + " 2013"
      selected_sale_time = ($ '#listing_time').val()
      selected_sale_date = new Date(full_sale_day + " " + selected_sale_time)
      formatted_sale_date = 
        if (selected_sale_day.length > 0)
          $.format.date(selected_sale_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      twitter_share = if ($ '.new_share.twitter').hasClass 'share_it' then true else false
      facebook_share = if ($ '.new_share.facebook').hasClass 'share_it' then true else false
      ticket_url = ($ '#listing_ticket_url').val()
      ($ '#listing_sale_date').val formatted_date
      ($ '#listing_intention').val intention
      ($ '#listing_date_and_time').val formatted_date
      ($ '#listing_ticket_option').val ticket_option
      ($ '#listing_sell_out').val sell_out
      data = {}
      data["listing_name"] = listing_name
      data["user_id"] = oApp.currentUser.id
      data["date_and_time"] = formatted_date
      data["intention"] = intention
      data["venue_name"] = venue_name
      data["venue_address"] = venue_address
      data["venue_url"] = venue_url
      data["lat"] = lat
      data["lng"] = lng
      data["event_description"] = event_description
      data["intention"] = intention
      data["ticket_option"] = ticket_option
      data["cost"] = cost
      data["sell_out"] = sell_out
      data["ticket_url"] = ticket_url
      data["sale_date"] = formatted_sale_date
      data["twitter_share"] = twitter_share
      data["facebook_share"] = facebook_share
      @model = new Listing;
      @model.save data, success: (data) =>
        console.log 'saved'
      unless _.include(@venue_names, venue_name)
        venue_data = {}
        venue_data["venue_name"] = venue_name
        venue_data["venue_address"] = venue_address
        venue_data["venue_url"] = venue_url
        venue_data["user_id"] = oApp.currentUser.id
        @venues.create venue_data
      return false

  submitEnter: (e) ->
    if ($ e.target).hasClass 'not_ready'
      ($ '.error_msg').addClass 'show'
  
  inputFocus: (e) ->
    
  inputBlur: (e) ->
    input = ($ e.target)
    if input.text().length > 0
      if input.attr('id') == 'listing_venue_address'
        @addMap(input)
    else
      # fix for breaks being inserted
      input.html('')
    if input.parents('.info_group').hasClass 'required_info'
      @checkRequired($ e.target)
    if ($ e.target).attr('id') == "listing_sale_day" || ($ e.target).attr('id') == 'listing_sale_time'
      @ticketCheck($ e.target)

  addMap: (input) ->
    og_address = input.val()
    address = og_address.toLowerCase()
    if address.indexOf(' ny')
      address = address + ' ny'
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: address, 
      region: 'us' 
    , (results, status) =>
      ($ '#map_area').addClass 'show'
      ($ '#map_option').addClass 'show'
      data = results[0]
      @map = {}
      lat = data.geometry.location.lat()
      lng = data.geometry.location.lng()
      @map.lat = lat
      @map.lng = lng
      map = new GMaps
        div: '#map_area',
        lat: lat,
        lng: lng
      map.addMarker
        lat: lat,
        lng: lng

  removeMap: ->
    ($ '#map_area').removeClass('show').html ''
    ($ '#map_option').removeClass 'show'
    @map = false

  ticketCheck: (target) ->
    if target.attr('id') == "listing_sale_day"
      date_list = window.getDates()
      setTimeout =>
        date_entered = target.val()
        if _.include(date_list, date_entered)
          target.removeClass 'invalid'
        else
          target.addClass 'invalid'
      , 200
    else if target.attr('id') == 'listing_sale_time'
      time_list = window.getTimes()
      setTimeout =>
        time_entered = ($ target).val()
        if _.include(time_list, time_entered)
          target.removeClass 'invalid'
        else
          target.addClass 'invalid'
      , 200

  checkRequired: (target) ->
    if target
      if target.attr('id') == "listing_day"
        date_list = window.getDates()
        setTimeout =>
          date_entered = target.val()
          if _.include(date_list, date_entered)
            target.removeClass 'invalid'
          else
            target.addClass 'invalid'
        , 200
      else if target.attr('id') == 'listing_time'
        time_list = window.getTimes()
        setTimeout =>
          time_entered = ($ target).val()
          if _.include(time_list, time_entered)
            target.removeClass 'invalid'
          else
            target.addClass 'invalid'
        , 200
    setTimeout ->
      name_check = ($ '#listing_listing_name').text().length > 0
      day_check = ($ '#listing_day').text().length > 0
      time_check = ($ '#listing_time').text().length > 0
      day_invalid = ($ '#listing_day').hasClass 'invalid'
      time_invalid = ($ '#listing_time').hasClass 'invalid'
      day_double_check = day_check && !day_invalid
      time_double_check = time_check && !time_invalid
      $error_box = ($ '.error_msg')
      if name_check && day_double_check && time_double_check
        ($ 'input[type="submit"]').removeClass 'not_ready'
        error_text = ''
        $error_box.removeClass 'show'
      else
        ($ 'input[type="submit"]').addClass 'not_ready'
        if !name_check
          if day_double_check && time_double_check
            error_text = 'An event name is required.'
          else
            if time_double_check
              error_text = 'An event name and day are required.'
            else if day_double_check
              error_text = 'An event name and time are required.'
            else
              error_text = 'An event name, day and time are required.'
        else if !day_double_check
          if name_check && time_double_check
            error_text = 'An event day is required.'
          else
            error_text = 'An event day and time are required.'
        else
          error_text = 'An event time is required.'
      $error_box.text error_text
    , 200

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
      fb_connect: true if oApp.currentUser.fb_token
      fb_default: oApp.currentUser.fb_default
      tw_connect: true if oApp.currentUser.tw_token
      tw_default: oApp.currentUser.tw_default
    ($ @el).html(HTML)
    setTimeout =>
      @initializeAutocomplete()
    , 0
    @

window.ListingCreate = Backbone.View.extend
  className: "panel"
  template: JST["templates/listings/new"]
  events:
    'click input[type="submit"]' : "createListing"
    'click .intention_container' : "showIntentions"
    'click .intention_container li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'click #map_option' : 'removeMap'
    'focus .input' : 'inputFocus'
    'blur .input' : 'inputBlur'
    'click .new_share' : 'toggleShare'
    'mouseenter input[type="submit"]' : 'submitEnter'
  
  initialize: (options) ->
    _.bindAll @
    @collection = options.collection
    @collection.unbind()
    @venues = new Venues
    @venues.fetch
      url: "venues.json"
      success: (collection, response) => 
        @venues = collection
        @venue_list = collection.models
        @venue_names = []
        _.each(@venue_list, (venue) =>
          @venue_names.push venue.attributes.venue_name
          venue.label = venue.attributes.venue_name
        )
        ($ '#listing_venue_name').autocomplete("option", "source", @venue_list)

  initializeAutocomplete: ->
    el = $('.listing_create_container')

    $("#listing_day").autocomplete
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getDates()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        matcher_three = new RegExp("\\b" + terms[2], "i") if term_count > 2
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
          else if term_count == 3
            return matcher.test(item) && matcher_two.test(item) && matcher_three.test(item)
        responseFn(a) 
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    $("#listing_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getTimes()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
        responseFn(a) 
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    $("#listing_sale_day").autocomplete
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getDates()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        matcher_three = new RegExp("\\b" + terms[2], "i") if term_count > 2
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
          else if term_count == 3
            return matcher.test(item) && matcher_two.test(item) && matcher_three.test(item)
        responseFn(a)
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none" 
    $("#listing_sale_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        setTimeout =>
          ($ @).blur()
        , 0
      source: (req, responseFn) ->
        wordlist = getTimes()
        term_input = req.term
        term = term_input.split("\ ")
        term_count = term.length
        terms = []
        i = 0
        while (i < term_count)
          terms.push($.ui.autocomplete.escapeRegex(term[i]))
          i++
        matcher = new RegExp("\\b" + terms[0], "i")
        matcher_two = new RegExp("\\b" + terms[1], "i")  if term_count > 1
        a = $.grep wordlist, (item) ->
          if term_count == 1
            return matcher.test item
          else if term_count == 2
            return matcher.test(item) && matcher_two.test(item)
        responseFn(a)
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"
    ($ '#listing_venue_name').autocomplete
      select: (event, ui) =>
        address = ui.item.attributes.venue_address
        url = ui.item.attributes.venue_url
        if address
          ($ '#listing_venue_address').val address
          @addMap($ '#listing_venue_address')
        if url
          ($ '#listing_venue_url').val url
      position:
        my: "left top",
        at: "left-10 bottom+5",
        collision: "none"

  toggleShare: (e) ->
    ($ e.target).toggleClass 'share_it'

  showIntentions: (e) ->
    if ($ e.target).hasClass('.intention_container')
      $container = ($ e.target)
    else
      $container = ($ e.target).parents('.intention_container')
    $options  = $container.find('.intention_select')
    if $options.hasClass 'active'
      $options.removeClass 'active'
      $container.removeClass 'active'
    else
      $options.addClass 'active'
      $container.addClass 'active'
  
  closeModal: ->
    ($ @el).remove()
    ($ '#main_column').removeClass('inactive')
    ($ '.listing.editing').removeClass 'editing'
    ($ '#create_event').removeClass('active').text('new event')
    return false

  intentionSelect: (e) ->
    $target = ($ e.target)
    $intention_container = $target.parents('.intention_container')
    $intention_select = $target.parents('.intention_select')
    $intention_selected = $intention_select.prev()
    $intention_selected.removeClass 'virgin'
    new_text = $target.text()
    $intention_container.removeClass('active').find('li').removeClass 'active'
    $target.addClass 'active'
    $intention_selected.html(new_text + '<div class="intention_triangle"></div>').removeClass 'active'
    if ($intention_container.attr('id') == "ticket_option")
      index = $intention_select.find('li').index(e.target)
      if (index == 0)
        ($ '.not_free').removeClass('hidden')
        ($ '.future_sale').addClass('hidden')
      else if (index == 1)
        ($ '.not_free').removeClass('hidden')
        ($ '.future_sale').removeClass('hidden')
      else if (index == 2)
        ($ '.not_free').addClass('hidden')
        ($ '.future_sale').addClass('hidden')
      else
        $intention_selected.addClass 'virgin'
        ($ '.not_free').addClass('hidden')
        ($ '.future_sale').addClass('hidden')
    
  createListing: (e) ->
    me = @
    if ($ e.target).hasClass 'not_ready'
      return false
    else
      me = @
      listing_name = ($ "#listing_listing_name").val()
      selected_day = ($ '#listing_day').val().toString()
      strip_day = selected_day.substr(selected_day.indexOf(" ") + 1)
      full_day = strip_day + " 2013"
      selected_time = ($ '#listing_time').val()
      selected_date = new Date(full_day + " " + selected_time)
      formatted_date = 
        if (selected_day.length > 0)
          $.format.date(selected_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      venue_name = ($ '#listing_venue_name').val()
      venue_address = ($ '#listing_venue_address').val()
      venue_url = ($ '#listing_venue_url').val()
      lat = @map.lat * 1000000 if @map
      lng = @map.lng * 1000000 if @map
      event_description = ($ '#listing_event_description').val()
      intention = ($ '#intention .intention_select').find('li.active').index()
      ticket_option = ($ '#ticket_option .intention_select').find('li.active').index()
      sell_out = ($ '#sell_out .intention_select').find('li.active').index()
      cost = ($ '#listing_cost').val()
      selected_sale_day = ($ '#listing_sale_day').val().toString()
      sale_strip_day = selected_sale_day.substr(selected_sale_day.indexOf(" ") + 1)
      full_sale_day = sale_strip_day + " 2013"
      selected_sale_time = ($ '#listing_time').val()
      selected_sale_date = new Date(full_sale_day + " " + selected_sale_time)
      formatted_sale_date = 
        if (selected_sale_day.length > 0)
          $.format.date(selected_sale_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      twitter_share = if ($ '.new_share.twitter').hasClass 'share_it' then true else false
      facebook_share = if ($ '.new_share.facebook').hasClass 'share_it' then true else false
      ticket_url = ($ '#listing_ticket_url').val()
      ($ '#listing_sale_date').val formatted_date
      ($ '#listing_intention').val intention
      ($ '#listing_date_and_time').val formatted_date
      ($ '#listing_ticket_option').val ticket_option
      ($ '#listing_sell_out').val sell_out
      data = {}
      data["listing_name"] = listing_name
      data["user_id"] = oApp.currentUser.id
      data["date_and_time"] = formatted_date
      data["intention"] = intention
      data["venue_name"] = venue_name
      data["venue_address"] = venue_address
      data["venue_url"] = venue_url
      data["lat"] = lat
      data["lng"] = lng
      data["event_description"] = event_description
      data["intention"] = intention
      data["ticket_option"] = ticket_option
      data["cost"] = cost
      data["sell_out"] = sell_out
      data["ticket_url"] = ticket_url
      data["sale_date"] = formatted_sale_date
      data["twitter_share"] = twitter_share
      data["facebook_share"] = facebook_share
      @collection.create data, success: (data) =>
        window.side_listings.add data
        @closeModal()
        index = @collection.indexOf(data)
        setTimeout ->
          me.insertListing(data, index)
        , 800
      unless _.include(@venue_names, venue_name)
        venue_data = {}
        venue_data["venue_name"] = venue_name
        venue_data["venue_address"] = venue_address
        venue_data["venue_url"] = venue_url
        venue_data["user_id"] = oApp.currentUser.id
        @venues.create venue_data
      return false

  insertListing: (model, index) ->
    view = new ListingView model: model
    new_listing = ($ view.render().el).addClass 'inserting added expanded'
    scroll_point = 0

    collection = @collection
    collection_length = collection.length
    listing_month = model.getMonth()

    before_match = false
    after_match = false
    month_insert = false
    first_listing = false

    if index != 0
      model_before = @collection.at(index - 1)
      month_before = model_before.getMonth()
      if listing_month == month_before
        before_match = true
    else
      first_listing = true
    if index != (collection_length - 1)
      model_after = @collection.at(index + 1)
      month_after = model_after.getMonth()
      if listing_month == month_after
        after_match = true

    month_insert = "<div class='month_container inserted'><div class='month'>#{listing_month}</div></div>"

    if first_listing == false
      listing_before = $('.events_listing .listing').eq(index-1)
      if before_match == false && after_match == false
        listing_before.after new_listing
        listing_before.after month_insert
      else if before_match == false
        listing_after = $('.events_listing .listing').eq(index+1)
        listing_after.before new_listing
      else
        listing_before.after new_listing
      scroll_point = ($ listing_before).offset().top + ($ listing_before).outerHeight() - 40
    else
      if after_match == false
        $('.events_listing').prepend new_listing
        $('.events_listing').prepend month_insert
      else
        listing_after = $('.events_listing .listing').eq(0)
        listing_after.before new_listing
      scroll_point = 0

    ($ 'body').animate
      scrollTop: scroll_point
    , 200, ->

      expand = -> 
        ($ new_listing).removeClass 'inserting'
        ($ '.month_container.inserted').removeClass 'inserted'
      setTimeout expand, 200
      fade_in = -> ($ new_listing).removeClass 'added'
      setTimeout fade_in, 600

  submitEnter: (e) ->
    if ($ e.target).hasClass 'not_ready'
      ($ '.error_msg').addClass 'show'
  
  inputFocus: (e) ->
    
  inputBlur: (e) ->
    input = ($ e.target)
    if input.text().length > 0
      if input.attr('id') == 'listing_venue_address'
        @addMap(input)
    else
      # fix for breaks being inserted
      input.html('')
    if input.parents('.info_group').hasClass 'required_info'
      @checkRequired($ e.target)
    if ($ e.target).attr('id') == "listing_sale_day" || ($ e.target).attr('id') == 'listing_sale_time'
      @ticketCheck($ e.target)

  addMap: (input) ->
    og_address = input.val()
    address = og_address.toLowerCase()
    if address.indexOf(' ny')
      address = address + ' ny'
    geocoder = new google.maps.Geocoder()
    geocoder.geocode
      address: address, 
      region: 'us' 
    , (results, status) =>
      ($ '#map_area').addClass 'show'
      ($ '#map_option').addClass 'show'
      data = results[0]
      @map = {}
      lat = data.geometry.location.lat()
      lng = data.geometry.location.lng()
      @map.lat = lat
      @map.lng = lng
      map = new GMaps
        div: '#map_area',
        lat: lat,
        lng: lng
      map.addMarker
        lat: lat,
        lng: lng

  removeMap: ->
    ($ '#map_area').removeClass('show').html ''
    ($ '#map_option').removeClass 'show'
    @map = false

  ticketCheck: (target) ->
    if target.attr('id') == "listing_sale_day"
      date_list = window.getDates()
      setTimeout =>
        date_entered = target.val()
        if _.include(date_list, date_entered)
          target.removeClass 'invalid'
        else
          target.addClass 'invalid'
      , 200
    else if target.attr('id') == 'listing_sale_time'
      time_list = window.getTimes()
      setTimeout =>
        time_entered = ($ target).val()
        if _.include(time_list, time_entered)
          target.removeClass 'invalid'
        else
          target.addClass 'invalid'
      , 200

  checkRequired: (target) ->
    if target
      if target.attr('id') == "listing_day"
        date_list = window.getDates()
        setTimeout =>
          date_entered = target.val()
          if _.include(date_list, date_entered)
            target.removeClass 'invalid'
          else
            target.addClass 'invalid'
        , 200
      else if target.attr('id') == 'listing_time'
        time_list = window.getTimes()
        setTimeout =>
          time_entered = ($ target).val()
          if _.include(time_list, time_entered)
            target.removeClass 'invalid'
          else
            target.addClass 'invalid'
        , 200
    setTimeout ->
      name_check = ($ '#listing_listing_name').text().length > 0
      day_check = ($ '#listing_day').text().length > 0
      time_check = ($ '#listing_time').text().length > 0
      day_invalid = ($ '#listing_day').hasClass 'invalid'
      time_invalid = ($ '#listing_time').hasClass 'invalid'
      day_double_check = day_check && !day_invalid
      time_double_check = time_check && !time_invalid
      $error_box = ($ '.error_msg')
      if name_check && day_double_check && time_double_check
        ($ 'input[type="submit"]').removeClass 'not_ready'
        error_text = ''
        $error_box.removeClass 'show'
      else
        ($ 'input[type="submit"]').addClass 'not_ready'
        if !name_check
          if day_double_check && time_double_check
            error_text = 'An event name is required.'
          else
            if time_double_check
              error_text = 'An event name and day are required.'
            else if day_double_check
              error_text = 'An event name and time are required.'
            else
              error_text = 'An event name, day and time are required.'
        else if !day_double_check
          if name_check && time_double_check
            error_text = 'An event day is required.'
          else
            error_text = 'An event day and time are required.'
        else
          error_text = 'An event time is required.'
      $error_box.text error_text
    , 200

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
      fb_connect: true if oApp.currentUser.fb_token
      fb_default: oApp.currentUser.fb_default
      tw_connect: true if oApp.currentUser.tw_token
      tw_default: oApp.currentUser.tw_default
    ($ @el).html(HTML)
    setTimeout =>
      @initializeAutocomplete()
    , 0
    @

window.ListingEdit = ListingCreate.extend
  template: JST["templates/listings/edit"]
  events:
    'click input[type="submit"]' : "createListing"
    'click .intention_container' : "showIntentions"
    'click .intention_container li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'click #map_option' : 'removeMap'
    'focus input' : 'inputFocus'
    'blur .input' : 'inputBlur'
    'click input[type="submit"]' : 'saveListing'
  
  initialize: () ->
    _.bindAll @
    if ($ '.text_container').length == 0
      ($ 'body').append '<div class="text_container"><div class="text_clone"></div></div>'
    @venues = new Venues
    @venues.fetch
      url: "venues.json"
      success: (collection, response) => 
        @venues = collection
        @venue_list = collection.models
        @venue_names = []
        _.each(@venue_list, (venue) =>
          @venue_names.push venue.attributes.venue_name
          venue.label = venue.attributes.venue_name
        )
        ($ '#listing_venue_name').autocomplete("option", "source", @venue_list)

  saveListing: (e) ->
    if ($ e.target).hasClass 'not_ready'
      return false
    else
      me = @
      selected_day = ($ '#listing_day').val().toString()
      strip_day = selected_day.substr(selected_day.indexOf(" ") + 1)
      full_day = strip_day + " 2013"
      selected_time = ($ '#listing_time').val()
      selected_date = new Date(full_day + " " + selected_time)
      formatted_date = 
        if (selected_day.length > 0)
          $.format.date(selected_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      venue_name = ($ '#listing_venue_name').val()
      venue_address = ($ '#listing_venue_address').val()
      venue_url = ($ '#listing_venue_url').val()
      lat = @map.lat * 1000000 if @map
      lng = @map.lng * 1000000 if @map
      event_description = ($ '#listing_event_description').val()
      intention = ($ '#intention .intention_select').find('li.active').index()
      ticket_option = ($ '#ticket_option .intention_select').find('li.active').index()
      sell_out = ($ '#sell_out .intention_select').find('li.active').index()
      cost = ($ '#listing_cost').val()
      selected_sale_day = ($ '#listing_sale_day').val().toString()
      sale_strip_day = selected_sale_day.substr(selected_sale_day.indexOf(" ") + 1)
      full_sale_day = sale_strip_day + " 2013"
      selected_sale_time = ($ '#listing_time').val()
      selected_sale_date = new Date(full_sale_day + " " + selected_sale_time)
      formatted_sale_date = 
        if (selected_sale_day.length > 0)
          $.format.date(selected_sale_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
        else
          false
      ticket_url = ($ '#listing_ticket_url').val()
      privacy = ($ '#privacy .intention_select').find('li.active').index()
      ($ '#listing_sale_date').val formatted_date
      ($ '#listing_intention').val intention
      ($ '#listing_date_and_time').val formatted_date
      ($ '#listing_ticket_option').val ticket_option
      ($ '#listing_sell_out').val sell_out
      data = {}
      data["listing_name"] = ($ "#listing_listing_name").val()
      data["user_id"] = oApp.currentUser.id
      data["date_and_time"] = formatted_date
      data["intention"] = intention
      data["venue_name"] = venue_name
      data["venue_address"] = venue_address
      data["venue_url"] = venue_url
      data["lat"] = lat
      data["lng"] = lng
      data["event_description"] = event_description
      data["intention"] = intention
      data["ticket_option"] = ticket_option
      data["cost"] = cost
      data["sell_out"] = sell_out
      data["ticket_url"] = ticket_url
      data["sale_date"] = formatted_sale_date
      @model.save data
      unless _.include(@venue_names, venue_name)
        venue_data = {}
        venue_data["venue_name"] = venue_name
        venue_data["venue_address"] = venue_address
        venue_data["venue_url"] = venue_url
        venue_data["user_id"] = oApp.currentUser.id
        @venues.create venue_data
      ($ '#main_column').removeClass 'inactive'
      ($ '#panel_container').html ''
      setTimeout ->
        ($ '.listing.editing').removeClass 'editing'
      , 200
      return false

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    intent_option = @model.getIntention()
    ticket_option = @model.getTicketOption()
    if intent_option == 0 
      intent_text = "I am going to"
    else if intent_option == 1 
      intent_text = "I am thinking about going to" 
    else
      intent_text = "I would go, if somebody else does, to"
    if ticket_option == 0 
      selected_text = "Tickets are on sale"
    else if ticket_option == 1 
      selected_text = "Tickets will go on sale" 
    else if ticket_option == 2
      selected_text = "It's free!"
    else
      selected_text = "Select a ticket option"
    sell_out = @model.getSellOut()
    if sell_out == 0 
      sell_text = "sell out immediately"
    else if sell_out == 1 
      sell_text = "sell out within a week" 
    else if sell_out == 2
      sell_text = "sell out within a month"
    else if sell_out == 3
      sell_text = "not sell out"
    else
      sell_text = "it sold out"
    HTML = @template
      token: token
      intent_text: intent_text
      intent_0: true if intent_option == 0
      intent_1: true if intent_option == 1
      intent_2: true if intent_option == 2
      name: @model.getName()
      id: @model.getID()
      day: @model.getFormDay()
      time: @model.getFormTime()
      venue_name: @model.getVenueName()
      venue_address: @model.getVenueAddress()
      venue_url: @model.getVenueUrl()
      description: @model.getEventDescription()
      ticket_0: true if ticket_option == 0
      ticket_1: true if ticket_option == 1
      ticket_2: true if ticket_option == 2
      ticket_3: true if ticket_option == 3
      sale_day: @model.getFormSaleDay()
      sale_time: @model.getFormSaleTime()
      sell_0: true if sell_out == 0
      sell_1: true if sell_out == 1
      sell_2: true if sell_out == 2
      sell_3: true if sell_out == 3
      sell_4: true if sell_out == 4
      sell_0: true if sell_out == 5
      cost: @model.getCost()
      ticket_url: @model.getTicketUrl()
      selected_text: selected_text
      sell_text: sell_text;
    ($ @el).html(HTML)
    setTimeout =>
      @initializeAutocomplete()
    , 0
    @

window.CreateButton = Backbone.View.extend
  template: JST["templates/create_event"]
  className: "create_container"
  events:
    "click #create_event" : "showCreate"
  
  initialize: (options) ->
    @collection = options.collection
  
  showCreate: (e) ->
    if ($ e.target).hasClass 'active'
      ($ e.target).removeClass('active').text 'create event'
      ($ '#panel_container').html ''
      ($ '#main_column').removeClass('inactive')
      return false
    else
      ($ e.target).addClass('active').text 'close form'
      ($ '#main_column').addClass('inactive')
      listing_create = new ListingCreate collection: @collection
      ($ '#panel_container').html listing_create.render().el  
      return false
  
  render: ->
    HTML = @template
    ($ @el).html HTML
    @

window.getDates = ->
  dates = []
  current = new Date()
  day = current.getDate()
  month = current.getMonth()
  year = current.getFullYear()   
  totalDays = ["31","28","31","30","31","30","31","31","30","31","30","31"]
  dayAmount = totalDays[month]
  totalMonths = month + 12
  while (month <= totalMonths)
    month++
    if (totalMonths - 11) == month
      d = day
    else
      d = 1
    while (d <= dayAmount)
      eachdate = new Date(year + "," + month + "," + d++)
      dates.push($.format.date(eachdate,"ddd") + ", " + $.format.date(eachdate,"MMMM") + " " + $.format.date(eachdate,"d"))
  dates

window.getTimes = ->
  times = []
  totalHours = 23
  intervals  = ["00","15","30","45"]
  hour = 0
  while (hour <= totalHours)
    hour++
    if hour < 13
      display_hour = hour
    else
      display_hour = hour - 12
    if hour < 12 || hour == 24
      suffix = " PM"
    else
      suffix = " AM"
    $.each intervals, (i, interval) ->
      times.push(display_hour + ":" + interval + suffix)
  times