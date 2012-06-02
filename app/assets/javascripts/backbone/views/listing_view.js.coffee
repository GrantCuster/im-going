window.ListingView = Backbone.View.extend
  template: JST["templates/listings/listing"]
  className: "listing group"
  events: 
    "click .main" : 'listingToggle'
    "click .going a" : "userLoad"
    "click .go_options li" : "intentionChoice"

  initialize: ->
    _.bindAll @, 'render'
    @model.bind 'change', @render, @

  listingToggle: ->
    if ($ @el).hasClass('expanded')
      ($ @el).removeClass('expanded')
      ($ @el).find('.main_bottom_container').css('height', '0')
    else
      bottom_height = ($ '.main_bottom').height()
      ($ @el).addClass('expanded').find('.main_bottom_container').css('height',bottom_height)
      setTimeout ->
        ($ @el).find('.main_bottom_container').addClass('reverse')

  userLoad: (e) ->
    window.router.navigate ($ e.target).attr('href'), {trigger: true}
    return false
  
  intentionChoice: (e) ->
    @intentions = @model.getIntentions()
    @intentions.bind 'add', @render, @
    intent = ($ e.target).index() + 1
    listing_id = @model.getID()
    user_id = oApp.currentUser.id
    data = {}
    data["listing_id"] = listing_id
    data["user_id"] = user_id
    data["intention"] = intent
    @intentions.create data
    return false

  render: ->
    user = @model.getUser()
    @intentions || = @model.getIntentions()
    if oApp.currentUser.id == @model.getUserID()
      user_listing = true
    else
      user_listing = false
    intented = false
    user_intent = false
    unless user_listing
      @intentions.each (intention) =>
        if intention.getUserID() == oApp.currentUser.id 
          intented = true
          user_intent = intention
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
      description: @model.getEventDescription()
      free: true if @model.getTicketOption() == 2
      urgency: @model.getSellOut()
      listing_month: @model.getSaleMonth()
      listing_day: @model.getSaleDay()
      cost: @model.getCost()
      ticket_display: true if (@model.getSaleMonth() || @model.getCost())
      ticket_url: @model.getTicketUrl()
      user_intent: user_intent.getText() if user_intent
      intentions: @intentions.order() if @intentions.length > 0
      listing_id: @model.getID()
    ($ @el).html HTML
    ($ @el).attr 'data-id', @model.getID()
    @

window.ListingsView = Backbone.View.extend
  className: "events_listing"
  template: JST["templates/listings/index"]
  
  initialize: ->
    _.bindAll @, 'initSubViews', 'render'
  
  addOne: (listing) ->
    window.side_listings.add(listing)
    @render()
  
  centerIt: (element) ->
    # window_width = $(window).width()
    # window_height = $(window).height()
    # element_width = element.width()
    # element_height = element.height()
    # left_pos = (window_width - element_width)/2
    # top_pos = 20
    # element.css
    #   left: left_pos,
    #   top: top_pos
  
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
        if (($(this).offset().top - 25) < ($ window).scrollTop())
          if !($ this).find('.month').hasClass 'active'
            ($ this).find('.month').addClass 'active'
            # prev_month_cont = month_conts[i+1]
            # ($ prev_month_cont).find('.month').addClass 'prev'
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


  initialize: (options) ->
    @options = options || ""

  base: ->
    window.router.navigate '', {trigger: true}

  render: ->
    me = @
    HTML = @template
      active: @options.active
    ($ @el).html HTML        
    @

window.SideListingsView = Backbone.View.extend
  className: "side_listing"
  template: JST["templates/listings/side_listings"]

  initialize: ->
    window.side_listings = @collection
    _.bindAll @, 'initSubViews', 'render'
    @collection.bind 'add', @addSide, @

  addSide: (listing) ->
    @render()

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
    listing_target = ($ '.listing[data-id="' + listing_id + '"]"')
    offset = listing_target.offset().top - 40
    ($ 'html, body').animate
      scrollTop: offset
    , 200, ->
      listing_target.addClass 'expanded'

  render: ->
    user = @model.getUser()
    HTML = @template
      username: user.username
      name: @model.getName()
      shortdate: @model.getShortDate()
      listing_id: @model.getID()
    ($ @el).html HTML
    @

window.ListingCreate = Backbone.View.extend
  className: "panel"
  template: JST["templates/listings/new"]
  events:
    'click input[type="submit"]' : "createListing"
    'click .intention_selected' : "showIntentions"
    'click .intention_select li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
    'focus input' : 'inputFocus'
    'blur input' : 'inputBlur'
  
  initialize: (collection) ->
    _.bindAll @
    if ($ '.text_container').length == 0
      ($ 'body').append '<div class="text_container"><div class="text_clone"></div></div>'
    @collection = collection
    @collection.unbind()
    @collection.bind 'add', @addTransition, @
    getDates()

  showIntentions: (e) ->
    ($ e.target).next().addClass 'active'
    ($ e.target).addClass('active')
  
  closeModal: ->
    ($ @el).remove()
    ($ '#main_column').removeClass('inactive')
    ($ '#create_event').removeClass('active').text('new event')
    ($ '.month_container').removeClass 'retract'
    return false
  
  intentionSelect: (e) ->
    $target = ($ e.target)
    $intention_container = $target.parents('.intention_container')
    $intention_select = $target.parents('.intention_select')
    $intention_selected = $intention_select.prev()
    new_text = $target.text()
    $intention_select.removeClass('active').find('li').removeClass 'active'
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
      else
        ($ '.not_free').addClass('hidden')
        ($ '.future_sale').addClass('hidden')
        
    
  createListing: ->
    me = @
    selected_day = ($ '#listing_day').val().toString()
    strip_day = selected_day.substr(selected_day.indexOf(" ") + 1)
    full_day = strip_day + " 2012"
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
    event_description = ($ '#listing_event_description').val()
    intention = ($ '#intention .intention_select').find('li.active').index()
    ticket_option = ($ '#ticket_option .intention_select').find('li.active').index()
    sell_out = ($ '#sell_out .intention_select').find('li.active').index()
    cost = ($ '#listing_cost').val()
    selected_sale_day = ($ '#listing_sale_day').val().toString()
    sale_strip_day = selected_sale_day.substr(selected_sale_day.indexOf(" ") + 1)
    full_sale_day = sale_strip_day + " 2012"
    selected_sale_time = ($ '#listing_time').val()
    selected_sale_date = new Date(full_sale_day + " " + selected_sale_time)
    formatted_sale_date = 
      if (selected_sale_day.length > 0)
        $.format.date(selected_sale_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
      else
        false
    ticket_url = ($ '#listing_ticket_url').val()
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
    data["event_description"] = event_description
    data["intention"] = intention
    data["ticket_option"] = ticket_option
    data["cost"] = cost
    data["sell_out"] = sell_out
    data["ticket_url"] = ticket_url
    data["sale_date"] = formatted_sale_date
    @collection.create data
    ($ '#panel_container').addClass('creating').find('#listing_listing_name').addClass('transition').width(500)
    return false
  
  addTransition: (listing, collection) ->
    scroll_modifier = 0
    new_listing = false
    collection.find (model, index) =>
      if model.getID() == listing.getID()
        @insert_index = index
    collection_length = collection.length
    view = new ListingView(model: listing)
    new_listing = view.render().el
    ($ new_listing).addClass 'expanded prepare'
    listing_month = listing.getMonth()
    if @insert_index != 0
      object_before = ($ ".events_listing .listing:eq(#{@insert_index - 1})")
      model_before = collection.at(@insert_index - 1)
      month_prev = model_before.getMonth()
      if (@insert_index + 1) != collection_length
        model_after = collection.at(@insert_index + 1)
        month_next = model_after.getMonth()
        if month_prev != listing_month
          if month_next != listing_month
            scroll_modifier = 60
            month_insert = "<div class='month_container inserted'><div class='month'>#{listing.getMonth()}</div></div>"
            object_before.after new_listing
            ($ new_listing).before month_insert
          else
            console.log object_before.next()
            object_before.next().after new_listing
        else
          object_before.after new_listing
      else
        if month_prev != listing_month
          scroll_modifier = 60
          month_insert = "<div class='month_container inserted'><div class='month'>#{listing.getMonth()}</div></div>"
          object_before.after new_listing
          ($ new_listing).before month_insert
        else
          object_before.after new_listing
    else
      if collection_length == 1
        scroll_modifier = 60
        month_insert = "<div class='month_container inserted'><div class='month'>#{listing.getMonth()}</div></div>"
        ($ '.events_listing').prepend new_listing
        ($ new_listing).before month_insert
      else
        model_after = collection.at(@insert_index + 1)
        month_next = model_after.getMonth()
        if month_next != listing_month
          scroll_modifier = 60
          month_insert = "<div class='month_container inserted'><div class='month'>#{listing.getMonth()}</div></div>"
          ($ '.events_listing').prepend new_listing
          ($ new_listing).before month_insert
        else
          ($ '.events_listing .month_container').first().after new_listing          
    new_height = ($ new_listing).height()
    ($ new_listing).before '<div class="insertion_spacer"></div>'
    new_pos = ($ new_listing).offset().top
    console.log ($ new_listing)
    insertion_pos = ($ '#new_listing').offset().top - ($ '#panel_container').offset().top
    scroll_pos = (new_pos - insertion_pos) + scroll_modifier
    ($ 'html, body').animate
      'scrollTop' : scroll_pos
    , 400, ->
      ($ '.month_container').removeClass 'inserted'
      ($ '.insertion_spacer').animate
        'height' : new_height
      , 200, ->
        ($ new_listing).addClass 'transition'
        setTimeout =>
          ($ new_listing).addClass 'move_it'
          ($ '#main_column').removeClass 'inactive'
          setTimeout ->
            ($ '#panel_container').removeClass('creating').html ''
            ($ '#create_event').removeClass('active').text 'new event'
            ($ '.insertion_spacer').remove()
            ($ '.month_container').removeClass 'retract'
            setTimeout ->
              ($ '.listing.prepare').removeClass 'prepare transition move_it'
            , 200
          , 200
        , 400
  
  inputFocus: (e) ->
    input = ($ e.target)
    new_width = input.attr('data-og-width')
    input.width new_width
    
  inputBlur: (e) ->
    input = ($ e.target)
    if input.val().length > 0
      characters = input.val()
      ($ '.text_clone').text(characters)
      new_width = ($ '.text_clone').width() + 15
      input.width(new_width)
    else
      @placeholderSize(e.target)

  placeholderSize: (input) ->
    if !($ input).attr('data-og-width')
      og_width = ($ input).css('width')
      ($ input).attr('data-og-width',og_width)
    placeholder = ($ input).attr('placeholder')
    ($ '.text_clone').text(placeholder)
    if ($ input).val().length > 0
      characters = ($ input).val()
      ($ '.text_clone').text(characters)
    new_width = ($ '.text_clone').width() + 15
    ($ input).width new_width

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
    ($ @el).html(HTML)
    ($ @el).find('input').not('input[type="submit"]').each (index, input) =>
      @placeholderSize(input)
    @

window.CreateButton = Backbone.View.extend
  template: JST["templates/create_event"]
  className: "create_container"
  events:
    "click #create_event" : "showCreate"
  
  showCreate: (e) ->
    ($ e.target).addClass('active').text 'reset form'
    ($ '#main_column').addClass('inactive')
    ($ '.month_container').addClass 'retract'
    listing_create = new ListingCreate @collection
    ($ '#panel_container').html listing_create.render().el
    el = $('.listing_create_container')
    $("#listing_day").autocomplete
      select: (event, ui) ->
        selected_date = ($ ui.item).val().toString()
        ($ '.text_clone').text(selected_date)
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
    $("#listing_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        selected_date = ($ ui.item).val().toString()
        ($ '.text_clone').text(selected_date)
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
    $("#listing_sale_day").autocomplete
      select: (event, ui) ->
        selected_date = ($ ui.item).val().toString()
        ($ '.text_clone').text(selected_date)
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
    $("#listing_sale_time").autocomplete
      open: (event, ui) ->
        ($ '.ui-autocomplete:visible').width(100)
      select: (event, ui) ->
        selected_date = ($ ui.item).val().toString()
        ($ '.text_clone').text(selected_date)
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