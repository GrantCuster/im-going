window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"

  initialize: ->
    _.bindAll @

  render: ->
    HTML = @template
      name: @model.getName()
    $(@el).html HTML
    @