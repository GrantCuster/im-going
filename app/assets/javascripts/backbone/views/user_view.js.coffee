window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"

  initialize: ->
    _.bindAll @

  render: ->
    console.log @model
    HTML = @template
      name: @model.getName()
      image: @model.getImageURL()
      description: @model.getDescription()
    ($ @el).html HTML
    @