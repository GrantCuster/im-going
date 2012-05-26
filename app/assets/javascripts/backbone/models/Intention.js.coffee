window.Intention = Backbone.Model.extend
  initialize: (options) ->
    @urlRoot = '/intentions'
  
  getUserId: -> @get "user_id"
  getIntention: -> @get "intention"
  getUser: -> new User(@get "user")

window.Intentions = Backbone.Collection.extend
  model: Intention
  
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
      user_id = intention.getUserId()
      if intention_one_count == 1
        intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> is going. "
      else
        if i == intention_one_count - 1
          intention_choices = intention_choices + " and <a href='#{user_id}'>#{username}</a> are going. "
        else if i == intention_one_count - 2
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a>, "
    intention_two_count = intention_two.length
    _.each intention_two, (intention, i) ->
      username = intention.getUser().getName()
      user_id = intention.getUserId()
      if intention_one_count == 1
        intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> is thinking about it. "
      else
        if i == intention_two_count - 1
          intention_choices = intention_choices + " and <a href='#{user_id}'>#{username}</a> are thinking about it. "
        else if i == intention_two_count - 2
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a>, "
    intention_three_count = intention_two.length
    _.each intention_three, (intention, i) ->
      username = intention.getUser().getName()
      user_id = intention.getUserId()
      if intention_one_count == 1
        intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> would go if somebody else does. "
      else
        if i == intention_three_count - 1
          intention_choices = intention_choices + " and <a href='#{user_id}'>#{username}</a> would go if somebody else does. "
        else if i == intention_three_count - 2
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a> "
        else
          intention_choices = intention_choices + "<a href='#{user_id}'>#{username}</a>, "
    intention_choices