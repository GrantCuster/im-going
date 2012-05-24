window.Intention = Backbone.Model.extend
  initialize: (options) ->
    @urlRoot = '/intentions'
  
  getUserId: -> @get "user_id"
  getIntention: -> @get "intention"

window.Intentions = Backbone.Collection.extend
  model: Intention
  
  order: ->
    intention_one = []
    intention_two = []
    intention_three = []
    this.each (intention) ->
      intention_choice = intention.getIntention()
      if intention_choice == 1
        intention_choices.push intention_choice
      else if intention_choice == 2
        intention_two.push intention_choice
      else
        intention_three.push intention_choice
    intention_choices = [intention_one,intention_two,intention_three]
    intention_choices