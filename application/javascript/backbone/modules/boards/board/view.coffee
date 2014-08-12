@Paperboard.module "Boards.Board", (Board, App, Backbone, Marionette, $, _) ->

  Board.Article = Marionette.ItemView.extend
    tagName: "article"
    template: "board-article"

    serializeData: ->
      model = @model.toJSON()
      data = {
        title: model.name
        description: model.description
        image: false
      }

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
      $(window).scroll @pageScroll

    onDomRefresh: ->
      $(window).scrollTop 0
      if @setup then @ui.wrapper.masonry()

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
      height = $(window).height()

      if $target.scrollTop() >= ($target.height() - height - 500)
        do @fetchMore

    onBeforeClose: ->
      $(window).unbind 'scroll'
      if @setup then @ui.articles.masonry 'destroy'

    onRender: ->
      console.log 'render'
      @ui.articles.masonry
        itemSelector: 'article'
        columnWidth: 'article'
        isAnimated: false
        gutter: 0
        transitionDuration: 0

    attachLazyLoad: ->
      @$el.find('.lazy').removeClass('lazy').lazyload
        effect: "fadeIn"
        container: @ui.articles
        threshold : 400

    attachHtml: (collectionView, itemView, index) ->
      if collectionView.isBuffering
        collectionView.elBuffer.appendChild itemView.el
      else
        @ui.articles.append itemView.el
        @ui.articles.masonry 'appended', itemView.el

        if @collection.length > 0 and index is (@collection.length-1)

          if not @loadMore
            @firstLayout = true

            window.setTimeout =>
              @ui.articles.masonry()
            , 1

            window.setTimeout =>
              if @ui.articles.height() < App.$window.height() then do @fetchMore
            , 500

          do @attachLazyLoad

    onDomRefresh: ->
      if @collection.length is 0 then do @fetch

    appendHtml: (collectionView, buffer) ->
      @ui.articles.append buffer
      @ui.articles.masonry()