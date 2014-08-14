@Paperboard.module "Boards.Board", (Board, App, Backbone, Marionette, $, _) ->

  Board.Article = Marionette.ItemView.extend
    tagName: "article"
    template: "board-article"

    serializeData: ->
      model = @model.toJSON()
      data = {
        title: model.name
        description: model.description.replace /(<([^>]+)>)/ig,""
        image: false
        source: model.sources[0]
        published_ago: @model.publishedAgo()
        url_host: model.url_host.replace 'www.', ''
        url: model.url
      }

      if data.title.length > 160
        data.title = data.title.substring(0,159) + '&hellip;'

      if data.description.length > 160
        data.description = data.description.substring(0,159) + '&hellip;'

      if model.lead_image
        data.image = model.lead_image
        if data.image and data.image.width and data.image.height
          data.image.ratio = (data.image.height * 100 / data.image.width).toFixed(2)
          if data.image.ratio > 150 then data.image.ratio = 149

      data

  # --------------------------------------------------------------------------

  Board.View = Marionette.CompositeView.extend
    template: "board"
    tagName: "section"
    className: "board"
    childView: Board.Article
    childViewContainer: ".articles"

    # Indicates whether the masonry instance has been initialized
    setup: false

    # Indicates whether the first masonry layout has been called after appending all the elements
    firstLayout: false

    # Indicates whether the view has already fetched for extra articles
    loadMore: false

    ui:
      articles: ".articles"

    initialize: ->
      _.bindAll @, 'pageScroll'

    fetch: ->
      @fetching = true
      @collection.fetch
        success: =>
          @fetched = true
          @fetching = false
          if @collection.length is 0
            @render()

    fetchMore: ->
      return if @fetching
      @fetching = true
      if @firstLayout then @loadMore = true
      @collection.fetchMore =>
        @fetching = false

    pageScroll: (event) ->
      return if @fetching or not @firstLayout
      $target = $ event.target

      if $target.scrollTop() >= ($target.height() - App.$window._height - 650)
        do @fetchMore

    onBeforeDestroyCollection: ->
      @ui.articles.masonry 'destroy'

    onBeforeDestroy: ->
      App.$window.off "scroll", @pageScroll

    onRenderTemplate: ->
      App.$window.on "scroll", @pageScroll

      @ui.articles.masonry
        itemSelector: 'article'
        columnWidth: 'article'
        isAnimated: false
        gutter: 0
        transitionDuration: 0

    onRenderCollection: ->
      do @attachLazyLoad
      @firstLayout = true

      window.setTimeout =>
        @ui.articles.masonry('layout')
      , 1

      window.setTimeout =>
        if @ui.articles.height() < App.$window.height() then do @fetchMore
      , 500

    attachLazyLoad: ->
      @$el.find('.lazy').removeClass('lazy').lazyload
        effect: "fadeIn"
        container: @ui.articles
        threshold : 400

    attachHtml: (collectionView, itemView, index) ->
      if itemView.model.get('description') isnt '' and itemView.model.get('lead_image')
        @ui.articles.append itemView.el
        @ui.articles.masonry 'addItems', itemView.el

      if @collection.length > 0 and index is (@collection.length-1)
        do @onRenderCollection

    onRender: ->
      if @collection.length is 0 then do @fetch