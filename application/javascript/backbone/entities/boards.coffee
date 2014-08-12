@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Board = Backbone.AuthModel.extend
    _class: "Board"
    idAttribute: 'private_id'
    defaults:
      private_id: 0
      name: ""

    url: ->
      "v3/collections/#{@get('private_id')}"

    initialize: ->
      @articles = new Entities.Articles [], board: @

  # --------------------------------------------------------------------------

  Entities.Boards = Backbone.AuthCollection.extend
    _class: "Boards"
    model: Entities.Board
    url: "v3/collections"

  # --------------------------------------------------------------------------

  App.reqres.setHandler "find:board", (private_id, callback) ->
    board = undefined
    for b in App.boards.models
      if b.get('private_id') is private_id
        board = b
        break

    return callback(board) if board

    board = new App.Entities.Board private_id: private_id
    board.fetch
      success: ->
        console.log 1
        callback(board)
      error: ->
        console.log 2
        callback null