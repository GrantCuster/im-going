window.Comment = Backbone.Model.extend
  urlRoot: '/comments'
  
  getUserId: -> @get "user_id"
  getComment: -> @get "comment"
  getListingId: -> @get "listing_id"
  getUser: -> new User(@get "user")
  getDateTime: -> 
    d = new Date Date.parse(@get "created_at")
    date = $.format.date(d,"M/d ha")
    date = date.slice(0, (date.length - 1))
    date

window.Comments = Backbone.Collection.extend
  model: Comment
  url: '/comments'