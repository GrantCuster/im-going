window.Listing = Backbone.Model.extend
  urlRoot: ->
    id = @get "id"
    "/listings/"

  getID: -> @get "id"
  getName: -> @get "listing_name"
  getIntention: -> @get "intention"
  getDateTime: -> 
    d = new Date Date.parse(@get "date_and_time")
    d.toString()
  getDay: -> $.format.date(@getDateTime(),"ddd").substr(0,3)
  getFullDay: -> $.format.date(@getDateTime(),"ddd")
  getDate: -> 
    date = $.format.date(@getDateTime(),"d")
    digit = date.charAt( date.length-1 )
    if date.length == 2 && date.charAt(0) == "1"
      date = date + 'th'
    else
      if digit == '1'
        date = date + 'st'
      else if digit == '2'
        date = date + 'nd'
      else if digit == '3'
        date = date + 'rd'
      else
        date = date + 'th'
    date
  getTime: -> 
    time = $.format.date(@getDateTime(),"ha").toString()
    time_stripped = time.replace("M", "")
    time_stripped
  getFullTime: -> $.format.date(@getDateTime(),"h:mm a").toString()
  getMonth: -> $.format.date(@getDateTime(),"MMMM")
  getPermalinkDate: -> @getFullDay() + ", " + @getMonth() + " " + @getDate()
  getFormDay: ->
    $.format.date(@getDateTime(), "ddd, MMMM dd")
  getFormTime: ->
    $.format.date(@getDateTime(), "h:mm a")
  getUser: -> @get "user"
  getUserID: -> @get "user_id"
  getIfMap: -> if @get "lat" then true else false
  getLat: -> 
    lat_raw = @get "lat"
    lat_raw/1000000
  getLng: ->
    lng_raw = @get "lng"
    lng_raw/1000000
  getTicketOption: -> @get "ticket_option"
  getUrgency: ->
    if @getTicketOption() == "1" || @getTicketOption() == "2"
      urgency = false
    else
      options_num = @get "sell_out"
      if options_num == 3
        urgency = "sold_out"
      else if options_num == 4
        urgency = "green"
      else
        if options_num == 0
          days = 0
        else if options_num == 1
          days = 7
        else if options_num == 2
          days = 30
        current_date = new Date
        sale_date = @getSaleDate()
        if sale_date
          d = new Date Date.parse(@getSaleDate())
        else
          d = new Date Date.parse(@get "created_at")
        d.setDate(d.getDate() + days)
        days_until = (d - current_date)/86400000
        if days_until < 2
          urgency = "red"
        else if days_until < 7
          urgency = "orange"
        else
          urgency = "green"
      urgency
  getSellOut: -> @get "sell_out"
  getSaleDate: -> 
    sale_date = @get "sale_date"
    if sale_date
      d = new Date Date.parse(sale_date)
      current_date = new Date
      if d < current_date
        false
      else
        sale_date
    else
      false
  getSaleMonth: ->
    if @getSaleDate()
      date = $.format.date(@getSaleDate(),"M")
      date
  getSaleDay: ->
    if @getSaleDate()
      date = $.format.date(@getSaleDate(),"d")
      date
  getFormSaleDay: ->
    if @getSaleDate()
      $.format.date(@getSaleDate(), "ddd, MMMM dd")
  getFormSaleTime: ->
    if @getSaleDate()
      $.format.date(@getSaleDate(), "h:mm a")
  getSaleTip: ->
    if @getSaleDate()
      date = $.format.date(@getSaleDate(),"ddd, MMMM dd")
      digit = date.charAt( date.length-1 )
      if digit == '1'
        date = date + 'st'
      else if digit == '2'
        date = date + 'nd'
      else if digit == '3'
        date = date + 'rd'
      else
        date = date + 'th'
      date
  getCost: -> @get "cost"  
  getTicketUrl: -> @get "ticket_url"
  getUserID: -> @get "user_id"
  getIntentions: ->
    listing_intention = new Intention( intention: this.getIntention() + 1, user_id: this.getUserID(), user: this.getUser() )
    intentions = new Intentions([listing_intention])
    other_intentions = @get "intentions"
    intentions.add(other_intentions)
    intentions
  getVenueName: -> @get "venue_name"
  getVenueAddress: -> @get "venue_address"
  getVenueUrl: -> @get "venue_url"
  getEventDescription: -> @get "event_description"
  getShortDate: -> $.format.date(@getDateTime(),"M/d")
  getComments: -> @get "comments"
  getSnippet: ->
    intentions = @getIntentions()
    @text = ""
    intentions.each (intention) =>
      if intention.getUserID() == oApp.currentUser.id
        intent_num = @getIntention()
        if intent_num == 0
          @text = "I am going to "
        else if intent_num == 1
          @text = "I am thinking about going to "
        else
          @text = "I would go, if somebody else does, to "
    if @text == ""
      @text = "Event: "
    name = @getName()
    url = "http://going.im/listings/#{@getID()}"
    message = @text + name + ": " + url
    message

window.Listings = Backbone.Collection.extend
  model: Listing
  url: "/listings"
  comparator: (listing) -> 
    d = new Date Date.parse(listing.get("date_and_time"))
    (d.getTime())

window.SideListings = Backbone.Collection.extend
  model: Listing
  comparator: (listing) -> 
    0 - listing.getID()

  initialize: ->