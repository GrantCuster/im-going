window.ListingView = Backbone.View.extend
  template: JST["templates/listings/listing"]
  className: "listing group"
  events: 
    "click .main" : 'listingToggle'
    "click .going a" : "userLoad"

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
    user_id = ($ e.target).attr('href')
    view = new UserView model: @model.getUser()
    ($ '.side_content').html view.render().el
    return false

  render: ->
    HTML = @template
      name: @model.getName()
      username: @model.getUser().attributes.username
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
    ($ @el).html HTML
    @

window.ListingsView = Backbone.View.extend
  className: "events_listing"
  template: JST["templates/listings/index"]
  events:
    "click #create_event" : "showCreate"
  
  initialize: ->
    _.bindAll @, 'initSubViews', 'render'
    @collection.bind 'add', @addOne, @
  
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
  
  showCreate: (e) ->
    ($ e.target).addClass('active').text 'reset form'
    ($ '#main_column').addClass('inactive')
    listing_create = new ListingCreate @collection
    ($ '#panel_container').html listing_create.render().el
    el = $('.listing_create_container')
    $('#main_column').bind('transitionend', -> el.css('opacity',1))
    @centerIt(el)
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
        ($ me.el).find('.listing:last-child').addClass 'last_of_month'
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

  initialize: ->
    _.bindAll @, 'render'
    @model.bind 'change', @render, @

  render: ->
    HTML = @template
      name: @model.getName()
      shortdate: @model.getShortDate()
    ($ @el).html HTML
    @

window.ListingCreate = Backbone.View.extend
  className: "panel_container"
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
    getDates()

  showIntentions: (e) ->
    ($ e.target).next().addClass 'active'
    ($ e.target).addClass('active')
  
  closeModal: ->
    ($ @el).remove()
    ($ '#main_column').removeClass('inactive')
    ($ '#create_event').removeClass('active').text('new event')
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
    console.log formatted_sale_date
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
    ($ @el).hide()
    ($ '#main_column').removeClass('inactive')
    return false
  
  inputFocus: (e) ->
    input = ($ e.target)
    new_width = input.attr('data-og-width')
    input.width new_width
  
  checkIt: ->
    console.log 'check it'
  
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