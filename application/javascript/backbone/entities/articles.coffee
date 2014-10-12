@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Article = Backbone.AuthModel.extend
    _class: "Article"
    defaults:
      name: ''
      type: 'feed'
      published_at: 0

    url: ->
      "v3/articles/#{@get('id')}"

    publishedAgo: ->
      published = moment(@get("published_at")*1000)
      if moment().diff(published, "days") > 7
        return published.format "LLLL"
      else
        return published.fromNow()

    topImage: ->
      img = @get 'lead_image'
      if img
        if img.width and img.height
          img.ratio = (img.height * 100 / img.width).toFixed(2)
          if img.ratio > 150 then img.ratio = 149
        return img
      false

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
      if @length then url += '?limit=50&max_timestamp=' + encodeURIComponent(@last().get('published_at'))

      @fetch
        url: url
        update: true
        add: true
        remove: false
        success: ->
          callback true
        error: =>
          callback false

