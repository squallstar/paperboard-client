@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.View = Marionette.ItemView.extend
    id: "novel"
    template: "novel-article"

    events:
      "click .close-novel" : "closeNovel"

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

    closeNovel: (event) ->
      do event.preventDefault
      do @destroy
      #TODO: navigate to prev url (silent)

    onDomRefresh: ->
      @$el.find('.nano').nanoScroller
        iOSNativeScrolling: true

      @$el.find('.html-content *').removeAttr('style').removeAttr('id').removeAttr('class')
      @$el.find('.html-content iframe').removeAttr('width').removeAttr('height')

    onDestroy: ->
      @$el.find('.nano').nanoScroller stop:true