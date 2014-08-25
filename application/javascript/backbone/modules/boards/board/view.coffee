@Paperboard.module "Boards.Board", (Board, App, Backbone, Marionette, $, _) ->

  Board.Settings = Marionette.ItemView.extend
    className: "settings"
    template: "board-settings"

  # --------------------------------------------------------------------------

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
        url_host: if model.url_host then model.url_host.replace('www.', '') else false
        url: model.url
      }

      if model.type == 'instagram'
        data.title = data.description
        data.description = model.name

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

    ui:
      articles: ".articles"

    initialize: ->
      _.bindAll @, 'pageScroll'

    modelEvents: ->
      "hide:settings": "hideBoardSettings"
      "show:settings": "showBoardSettings"

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
      @collection.fetchMore =>
        @fetching = false

    showBoardSettings: ->
      unless @settings
        @settings = new Board.Settings
          model: @model
        @settings.render()
        @$el.append @settings.$el

      @$el.addClass 'with-settings'
      App.$window.resize()
      @ui.articles.masonry 'layout'

    hideBoardSettings: ->
      @$el.removeClass 'with-settings'
      App.$window.resize()
      @ui.articles.masonry 'layout'

    pageScroll: (event) ->
      return if @fetching or not @firstLayout
      $target = $ event.target

      if $target.scrollTop() >= ($target.height() - App.$window._height - 650)
        do @fetchMore

    onBeforeDestroyCollection: ->
      @ui.articles.masonry 'destroy'

    onBeforeDestroy: ->
      if @timeout then clearTimeout @timeout
      if @settings then @settings.destroy()

      if @$el.hasClass 'with-settings'
        @$el.removeClass 'with-settings'
        App.$window.resize()

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

      @ui.articles.masonry 'layout'

      if @timeout then clearTimeout @timeout
      @timeout = window.setTimeout =>
        if @ui.articles.height() < App.$window.height() then do @fetchMore
      , 500

    attachLazyLoad: ->
      @$el.find('.lazy').removeClass('lazy').lazyload
        effect: "fadeIn"
        container: @ui.articles
        threshold : 100

    attachHtml: (collectionView, itemView, index) ->
      if (itemView.model.get('description') isnt '' and itemView.model.get('lead_image')) or itemView.model.get('type') is 'instagram'
        @ui.articles.append itemView.el
        @ui.articles.masonry 'addItems', itemView.el

      if @collection.length > 0 and index is (@collection.length-1)
        do @onRenderCollection

    onRender: ->
      if @collection.length is 0 then do @fetch