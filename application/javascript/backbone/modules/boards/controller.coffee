@Paperboard.module "Boards", (Boards, App, Backbone, Marionette, $, _) ->

  Boards.Router = Marionette.AppRouter.extend
    routes:
      "everything" : "showEverything"
      "board/:id" : "showBoard"

    showEverything: ->

    showBoard: (id) ->
      App.request "find:board", id, (board) ->
        return App.navigate(App.rootRoute, true) unless board
        App.request "change:nav", board

        App.content.show new Boards.Board.View
          model: board
          collection: board.articles

  App.addInitializer ->
    new Boards.Router