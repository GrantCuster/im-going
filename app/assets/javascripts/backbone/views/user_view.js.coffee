window.UserView = Backbone.View.extend
  template: JST["templates/user_view"]
  className: "user_view"

  initialize: ->
    console.log 'initialize user'
    _.bindAll @

  render: ->
    console.log 'render'
    HTML = @template
      name: 'hi'
    ($ @el).html HTML
    @