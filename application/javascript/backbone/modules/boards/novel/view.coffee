@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.View = Marionette.ItemView.extend
    id: "novel"
    template: "novel-article"

    events:
      "click a.close-action"  : "closeNovel"
      "click .html-content a" : "didClickLink"

    ui:
      nano: '.nano'
      html: '.html-content'

    serializeData: ->
      data = @model.toJSON()

      if not data.content then data.content = data.description

      if data.type == 'instagram'
        data.content = data.name
        delete data.name

      data.published_ago = @model.publishedAgo()
      data.source = data.sources[0]
      data.content = '<p>' + data.content.replace(/(?:\n)/g, '</p><p>') + '</p>'
      data.img = if data.content.indexOf('<img') is -1 then @model.topImage() else false
      data

    didClickLink: (event) ->
      do event.preventDefault
      window.open $(event.currentTarget).attr('href'), '_blank'

    closeNovel: (event) ->
      do event.preventDefault
      App.request 'overlay:dismiss:animated'

      route = if Backbone.history.canGoBack() then Backbone.history.previousFragment() else App.rootRoute
      App.navigate route, {trigger: false, replace: false}
      App.execute 'set:title', ''

    onRender: ->
      @ui.html.find("a[href^='#'], aside, input, form, button, script, style, [class^='hid'], #creative_commons, header, footer, .pagination, .mtl, .author, [class^='publication'], .credit, [class^='social'], [class^='hp-'], #toc_container, .sharedaddy, .ad, .po, .sot, [class^='recommended-'], #also-related-links, .embedded-hyper, .source").remove()
      @ui.html.find('iframe').removeAttr('width').removeAttr('height')
      @ui.html.find('*').removeAttr('style').removeAttr('id').removeAttr('class').removeAttr('onclick')

      if not @model.get('content')?
        @model.set 'content', ''
        @ui.nano.css 'opacity', 0.75
        @model.fetch
          success: =>
            return if @isDestroyed
            do @render
            @$el.find('.nano').animate {opacity: 1}, 500
      else
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

    onDomRefresh: ->
      @ui.nano.nanoScroller
        iOSNativeScrolling: true

      # maybe needs to be improved to use imagesloaded
      @ui.nano.one =>
        return if @isDestroyed
        window.setTimeout =>
          @ui.nano.nanoScroller()
        , 1000

    onBeforeDestroy: ->
      @ui.nano.nanoScroller {stop: true}