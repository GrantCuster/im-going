window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"

  initialize: ->
    _.bindAll @

  render: ->
    console.log @model.getName()
    HTML = @template
      name: "grant"
    $(@el).html HTML
    @