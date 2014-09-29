@Paperboard.module "Boards.Novel", (Novel, App, Backbone, Marionette, $, _) ->

  Novel.View = Marionette.ItemView.extend
    className: "novel"
    template: "novel-article"

    events:
      "click .close-novel" : "closeNovel"

    templateHelpers: ->
      htmlcontent: '<p>' + @model.get('content').replace(/(?:\n)/g, '</p><p>') + '</p>'

    closeNovel: (event) ->
      do event.preventDefault
      do @destroy
      #TODO: navigate to prev url (silent)