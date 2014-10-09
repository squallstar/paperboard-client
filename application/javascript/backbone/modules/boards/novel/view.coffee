@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.View = Marionette.ItemView.extend
    id: "novel"
    template: "novel-article"

    events:
      "click .close-novel" : "closeNovel"
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
      data.content = '<p>' + data.content.replace(/Â/g, '').replace(/(?:\n)/g, '</p><p>') + '</p>'
      data.img = if data.content.indexOf('<img') is -1 then @model.topImage() else false
      data

    didClickLink: (event) ->
      do event.preventDefault
      window.open $(event.currentTarget).attr('href'), '_blank'

    closeNovel: (event) ->
      do event.preventDefault
      do @destroy
      #TODO: navigate to prev url (silent)

    onRender: ->
      @ui.html.find('.html-content *').removeAttr('style').removeAttr('id').removeAttr('class')
      @ui.html.find('.html-content iframe').removeAttr('width').removeAttr('height')
      @ui.html.find("a[href^='#']").remove()

    onDomRefresh: ->
      @ui.nano.nanoScroller
        iOSNativeScrolling: true

      # maybe needs to be improved to use imagesloaded
      @ui.nano.one =>
        window.setTimeout =>
          @ui.nano.nanoScroller()
        , 1000

    onDestroy: ->
      @$el.find('.nano').nanoScroller stop:true