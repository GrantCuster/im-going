class ImGoing.Models.Event extends Backbone.Model
  paramRoot: 'event'

  defaults:
    content: null
    user_id: null

class ImGoing.Collections.EventsCollection extends Backbone.Collection
  model: ImGoing.Models.Event
  url: '/'
