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

    suggested: ->
      if not @_suggested
        @_suggested = new Entities.SuggestedArticles [], article: @
      @_suggested

    siblings: ->
      if @collection and @collection._class is 'SiblingArticles'
        return @collection
      if not @_siblings
        @_siblings = new Entities.SiblingArticles [], article: @
      @_siblings

    setSiblings: (collection) ->
      @_siblings = collection

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

  # --------------------------------------------------------------------------

  Entities.SuggestedArticles = Backbone.AuthCollection.extend
    _class: "SuggestedArticles"
    model: Entities.Article

    initialize: (models, options) ->
      @article = options.article

    url: ->
      "v3/articles/#{@article.get('id')}/suggested?limit=15"

  # --------------------------------------------------------------------------

  Entities.SiblingArticles = Backbone.AuthCollection.extend
    _class: "SiblingArticles"
    model: Entities.Article

    initialize: (models, options) ->
      @article = options.article

    url: ->
      "v3/articles/#{@article.get('id')}/siblings?limit=30"
