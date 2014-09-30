@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.View = Marionette.ItemView.extend
    id: "novel"
    template: "novel-article"

    events:
      "click .close-novel" : "closeNovel"

    templateHelpers: ->
      content = @model.get('content') || @model.get('description')

      htmlcontent: '<p>' + content.replace(/(?:\n)/g, '</p><p>') + '</p>'
      img: if content.indexOf('<img') is -1 then @model.topImage() else false

    closeNovel: (event) ->
      do event.preventDefault
      do @destroy
      #TODO: navigate to prev url (silent)

    onDomRefresh: ->
      @$el.find('.nano').nanoScroller
        iOSNativeScrolling: true

    onDestroy: ->
      @$el.find('.nano').nanoScroller stop:true