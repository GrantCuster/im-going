window.ListingView = Backbone.View.extend
  template: JST["templates/listings/listing"]
  className: "listing"

  initialize: ->
    _.bindAll @, 'render'
    @model.bind 'change', @render, @

  render: ->
    HTML = @template
      name: @model.getName()
      email: @model.getUser().getName()
      day: @model.getDay()
      date: @model.getDate()
      time: @model.getTime()
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
  
  showCreate: ->
    console.log 'hey'
    ($ '#overlay').show()
    listing_create = new ListingCreate @collection
    ($ '#overlay').after listing_create.render().el
    @centerIt($('.listing_create_container'))
    $("#listing_day").autocomplete
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
        ($ '.ui-autocomplete:visible').width(70)
      select: (event, ui) ->
        selected_date = ($ ui.item).val().toString()
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
      $(($ '.month').get().reverse()).each ->
        if (($(this).offset().top) < ($ window).scrollTop())
          if !($ this).hasClass 'active'
            month_text = $(this).text()
            ($ '#month_text').text(month_text)
            ($ '.month').removeClass 'active'
          ($ this).addClass 'active'
          return false
      if (($('.month').offset().top) > ($ window).scrollTop())
        if ($ '.month').hasClass 'active'
          ($ '#month_text').text ''
          ($ '.month').removeClass 'active'

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
      email: @model.getUser().getName()
      shortdate: @model.getShortDate()
    ($ @el).html HTML
    @

window.ListingCreate = Backbone.View.extend
  className: "listing_create_container"
  template: JST["templates/listings/new"]
  events:
    'click input[type="submit"]' : "createListing"
    'click .intention_selected' : "showIntentions"
    'click .intention_select li' : "intentionSelect"
    'click .modal_close' : 'closeModal'
  
  initialize: (collection) ->
    _.bindAll @
    @collection = collection
    getDates()

  showIntentions: (e) ->
    console.log ($ e.target)
    ($ e.target).next().addClass 'active'
  
  closeModal: ->
    ($ @el).hide()
    ($ '#overlay').hide()
    return false
  
  intentionSelect: (e) ->
    $target = ($ e.target)
    $intention_select = $target.parents('.intention_select')
    $intention_selected = $intention_select.prev()
    new_text = $target.text()
    $intention_select.removeClass('active').find('li').removeClass 'active'
    $target.addClass 'active'
    $intention_selected.text new_text
    
  createListing: ->
    me = @
    selected_day = ($ '#listing_day').val().toString()
    strip_day = selected_day.substr(selected_day.indexOf(" ") + 1)
    full_day = strip_day + " 2012"
    selected_time = ($ '#listing_time').val()
    selected_date = new Date(full_day + " " + selected_time)
    formatted_date = $.format.date(selected_date,"yyyy-MM-dd HH:mm:ss GMT+0400")
    ($ '#listing_date_and_time').val formatted_date
    data = {}
    data["listing_name"] = ($ "#listing_listing_name").val()
    data["user_id"] = oApp.currentUser.id
    data["date_and_time"] = formatted_date
    @collection.create data
    ($ @el).hide()
    ($ '#overlay').hide()
    return false
  
  inputEntered: ->
    console.log 'hi'
    ($ @el).find('input').blur ->
      console.log 'blur'
      if $(this).val().length > 0
        console.log 'length'
        $(this).addClass 'text_entered'

  render: ->
    token = ($ 'meta[name="csrf-token"]').attr('content')
    HTML = @template
      token: token
    ($ @el).html(HTML)
    @inputEntered()
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