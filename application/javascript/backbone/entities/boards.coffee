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

    comparator: (model) ->
      parseInt model.get('position'), 10

    reorder: ->
      do @sort
      collection_ids = []
      for collection in @models
        #if not isNaN(id) or id is "favourite_collection" then collection_ids.push id
        collection_ids.push collection.get('private_id')

      Backbone.OAuth.post
        url : "v3/collections/reorder"
        data :
          collection_ids : collection_ids

      @

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
        callback(board)
      error: ->
        callback null