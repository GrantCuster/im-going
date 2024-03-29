window.Intention = Backbone.Model.extend
  urlRoot: '/intentions'
  
  getUserID: -> @get "user_id"
  getIntention: -> @get "intention"
  getUser: -> new User(@get "user")
  getText: ->
    intent = @getIntention()
    if intent == 1
      text = "I'm going."
    else if intent == 2
      text = "I'm thinking."
    else
      text = "I would."

window.Intentions = Backbone.Collection.extend
  model: Intention
  url: '/intentions'
  
  order: () ->
    intention_one = []
    intention_two = []
    intention_three = []
    intention_choices = ""
    this.each (intention) ->
      intention_choice = intention.getIntention()
      if intention_choice == 1
        intention_one.push intention
      else if intention_choice == 2
        intention_two.push intention
      else
        intention_three.push intention
    intention_one_count = intention_one.length
    _.each intention_one, (intention, i) ->
      username = intention.getUser().getName()
      user_id = intention.getUserID()
      if intention_one_count == 1
        intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> is going. "
      else
        if i == intention_one_count - 1
          intention_choices = intention_choices + " and <a href='/#{username}'>#{username}</a> are going. "
        else if i == intention_one_count - 2
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a>, "
    intention_two_count = intention_two.length
    _.each intention_two, (intention, i) ->
      username = intention.getUser().getName()
      user_id = intention.getUserID()
      if intention_two_count == 1
        intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> is thinking about it. "
      else
        if i == intention_two_count - 1
          intention_choices = intention_choices + " and <a href='/#{username}'>#{username}</a> are thinking about it. "
        else if i == intention_two_count - 2
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a>, "
    intention_three_count = intention_three.length
    _.each intention_three, (intention, i) ->
      username = intention.getUser().getName()
      user_id = intention.getUserID()
      if intention_three_count == 1
        intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> would go if somebody else does. "
      else
        if i == intention_three_count - 1
          intention_choices = intention_choices + " and <a href='/#{username}'>#{username}</a> would go if somebody else does. "
        else if i == intention_three_count - 2
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='/#{username}'>#{username}</a>, "
    intention_choices