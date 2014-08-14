@Paperboard.module "Boards", (Boards, App, Backbone, Marionette, $, _) ->

  Boards.Router = Marionette.AppRouter.extend
    appRoutes:
      "everything" : "showEverything"
      "board/:id"  : "showBoard"

  API =
    _loadBoard: (board) ->
      App.request "change:nav", board
      do board.articles.reset
      App.content.show new Boards.Board.View
        model: board
        collection: board.articles

    showEverything: ->
      API._loadBoard new App.Entities.Board
        name: "All boards"
        private_id: "everything"

    showBoard: (id) ->
      App.request "find:board", id, (board) ->
        return App.navigate(App.rootRoute, true) unless board
        API._loadBoard board

  App.addInitializer ->
    new Boards.Router
      controller: API