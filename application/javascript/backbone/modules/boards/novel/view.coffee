@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.SuggestedArticle = Marionette.ItemView.extend
    tagName: "a"
    template: 'novel-suggested-article'

    attributes: ->
      'href': "/article/#{@model.get('id')}"

    events:
      "click" : "didClick"

    didClick: (event) ->
      do event.preventDefault
      do event.stopPropagation
      App.request 'set:intent', @model
      App.navigate @$el.attr('href'), true

  # --------------------------------------------------------------------------

  Novel.SuggestedView = Marionette.CollectionView.extend
    childView: Novel.SuggestedArticle

    initialize: ->
      if @collection.length is 0
        @$el.css 'opacity', 0
        @collection.fetch
          success: =>
            @$el.animate opacity: 1, 250
            @$el.closest('.nano').nanoScroller()
      else
        do @render

  # --------------------------------------------------------------------------

  Novel.ArticleView = Marionette.ItemView.extend
    template: 'novel-article'

    events:
      "click .html-content a" : "didClickLink"

    ui:
      html: '.html-content'

    serializeData: ->
      data = @model.toJSON()

      if not data.content then data.content = data.description

      if data.type == 'instagram'
        data.content = data.name
        delete data.name

      data.source = data.sources[0]

      max_length = 35
      if data.source.full_name.length > max_length
        data.source.full_name = data.source.full_name.substr(0, max_length-1) + '&hellip;'

      data.published_ago = @model.publishedAgo()
      data.content = '<p>' + data.content.replace(/(?:\n)/g, '</p><p>') + '</p>'
      data.img = if data.content.indexOf('<img') is -1 then @model.topImage() else false
      data

    didClickLink: (event) ->
      do event.preventDefault
      window.open $(event.currentTarget).attr('href'), '_blank'

    onRender: ->
      @ui.html.find("a[href^='#'], aside, input, form, button, script, style, [class^='hid'], #creative_commons, header, footer, .pagination, .mtl, .author, [class^='publication'], .credit, [class^='social'], [class^='hp-'], #toc_container, .sharedaddy, .ad, .po, .sot, [class^='recommended-'], #also-related-links, .embedded-hyper, .source").remove()
      @ui.html.find('iframe').removeAttr('width').removeAttr('height')
      @ui.html.find('*').removeAttr('style').removeAttr('id').removeAttr('class').removeAttr('onclick')

      if not @model.get('content')?
        @model.set 'content', ''
        @$el.css 'opacity', 0.75
        @model.fetch
          success: =>
            return if @isDestroyed
            do @render
            @$el.animate {opacity: 1}, 500
      else
        $imgs = @ui.html.find('img[data-src]')
        $imgs.each ->
          $img = $ @
          $img.attr 'src', $img.attr('data-src')

        $imgs = @ui.html.find 'img'
        $imgs.load(->
          $img = $ @
          width = $img.width()
          if width < 200
            $img.remove()
          else if width > 450
            $img.removeAttr('width').removeAttr('height')
            $img.css 'min-width', '100%'
        ).error ->
          $img = $ @
          $img.closest('figure').remove()
          $img.remove()

  # --------------------------------------------------------------------------

  Novel.View = Marionette.ItemView.extend
    id: "novel"
    template: "novel"

    events:
      "click a.close-action"  : "closeNovel"
      "click .more .menu a"   : "didClickMoreSection"

    ui:
      nano: '.nano'
      articleNano: 'article .nano'
      articleContainer: 'article .nano-content'
      suggested: '.suggested'

    initialize: ->
      @articleView = new Novel.ArticleView
        model: @model

    serializeData: ->
      source_name: @model.get('sources')[0].full_name

    closeNovel: (event) ->
      do event.preventDefault
      App.request 'overlay:dismiss:animated'

      route = if Backbone.history.canGoBack() then Backbone.history.previousFragment() else App.rootRoute
      App.navigate route, {trigger: false, replace: false}
      App.execute 'set:title', ''

    didClickMoreSection: (event) ->
      do event.preventDefault
      $el = $ event.currentTarget
      return if $el.hasClass 'current'
      if @section then @section.destroy()

      @section = new Novel['SuggestedView']
        collection: @model[$el.data('model')]()
      @ui.suggested.html @section.$el

      $el.parent().contents().not($el).removeClass 'current'
      $el.addClass 'current'

    replaceArticleWith: (article) ->
      @model = article
      @articleView.model = article
      @articleView.$el.animate opacity:0.2, 300, =>
        @articleView.render()
        @articleView.$el.animate opacity:1, 300
        @ui.articleNano.nanoScroller()
        @ui.articleNano.contents().animate scrollTop:0, 200

    onRender: ->
      @ui.articleContainer.html @articleView.$el
      @articleView.render()

      @ts = window.setTimeout =>
        @$el.find('.more .menu a:eq(0)').click()
      , if @model.collection and @model.collection._class is 'SiblingArticles' then 0 else 1000

    onDomRefresh: ->
      @ui.nano.nanoScroller
        iOSNativeScrolling: true

      # maybe needs to be improved to use imagesloaded
      # @ui.articleNano.one =>
      #   return if @isDestroyed
      #   window.setTimeout =>
      #     @ui.articleNano.nanoScroller()
      #   , 1000

    onBeforeDestroy: ->
      if @ts then clearTimeout @ts
      if @section then @section.destroy()
      @articleView.destroy()
      @ui.nano.nanoScroller {stop: true}