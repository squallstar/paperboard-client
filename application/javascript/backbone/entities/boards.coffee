@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Board = Backbone.AuthModel.extend
    _class: "Board"
    idAttribute: 'private_id'
    defaults:
      private_id: 0
      name: ""
      tags_orig: []

    url: ->
      "v3/collections/#{@get('private_id')}"

    initialize: ->
      @articles = new Entities.Articles [], board: @

    isTwitterType: ->
      @get('type') is 'twitter'

    isInstagramType: ->
      @get('type') is 'instagram'

    isFeedlyType: ->
      @get('type') is 'feedly'

    isFollowed: ->
      @get('owned_collection') is false and @collection and @collection is App.boards

    isReadOnly: ->
      @get('private_id') is 'everything'

    isOwned: ->
      @get('owned_collection') is true and not @isReadOnly()

    canBeFollowed: ->
      @get('owned_collection') is false and not @isReadOnly()

    hasContexts: ->
      @get('owned_collection') or @isReadOnly()

    follow: (callback) ->
      Backbone.OAuth.post
        url: "/v3/collections/#{@get('private_id')}/follow"

        success: =>
          App.boards.add @
          if callback then callback true
        error: ->
          if callback then callback false

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

  Entities.SuggestedBoards = Entities.Boards.extend
    url: ->
      "v4/collections/suggested?tags=" + encodeURIComponent(@tags.join(','))

    initialize: (models, options) ->
      @tags = options.tags

    parse: (response) ->
      for board in response
        board.selected = false
      response

  # --------------------------------------------------------------------------

  App.reqres.setHandler "find:board", (private_id, callback) ->
    board = undefined
    for b in App.boards.models
      if b.get('private_id') is private_id
        board = b
        break

    if board
      if callback then callback(board)
      return board

    board = new App.Entities.Board private_id: private_id
    board.fetch
      success: ->
        if callback then callback(board)
      error: ->
        if callback then callback null
    board