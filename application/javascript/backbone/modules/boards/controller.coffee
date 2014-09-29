@Paperboard.module "Boards", (Boards, App, Backbone, Marionette, $, _) ->

  Boards.Router = Marionette.AppRouter.extend
    appRoutes:
      "everything"  : "showEverything"
      "board/:id"   : "showBoard"
      "article/:id" : "showArticle"

  API =
    _currentBoard: undefined

    _loadBoard: (board) ->
      API._currentBoard = board
      App.request "change:nav", board
      do board.articles.reset
      App.content.show new Boards.Board.View
        model: board
        collection: board.articles

    showEverything: ->
      App.navigate(App.rootRoute, true) unless App.user

      API._loadBoard new App.Entities.Board
        name: "All boards"
        private_id: "everything"

    showBoard: (id) ->
      App.request "find:board", id, (board) ->
        return App.navigate(App.rootRoute, true) unless board
        API._loadBoard board

    showArticle: (id) ->
      article = App.request 'intent'
      if article and article.id is id
        App.overlay.show new Boards.Novel.View
          model: article
      else
        App.navigate App.rootRoute, true

  App.reqres.setHandler "load:board", (board) ->
    App.navigate "board/#{board.get('private_id')}", {trigger: false}
    API._loadBoard board

  App.addInitializer ->
    new Boards.Router
      controller: API