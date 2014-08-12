@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Article = Backbone.Model.extend
    _class: "Article"
    defaults:
      name: ""
      published_at: 0

    publishedAgo: ->
      published = moment(@get("published_at")*1000)
      if moment().diff(published, "days") > 7
        return published.format "LLLL"
      else
        return published.fromNow()

  # --------------------------------------------------------------------------

  Entities.Articles = Backbone.AuthCollection.extend
    _class: "Articles"
    model: Entities.Article

    initialize: (models, options) ->
      @board = options.board

    url: ->
      "v3/collections/#{@board.get('private_id')}/links"

    fetchMore: (callback) ->
      url = @url()
      if @length then url += '?max_timestamp=' + encodeURIComponent(@last().get('published_at'))

      @fetch
        url: url
        update: true
        add: true
        remove: false
        success: ->
          callback true
        error: =>
          callback false