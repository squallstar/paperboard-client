@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.Board = Backbone.AuthModel.extend
    _class: "Board"
    defaults:
      name: ""

    initialize: ->
      @articles = new Entities.Articles [], board: @

  # --------------------------------------------------------------------------

  Entities.Boards = Backbone.AuthCollection.extend
    _class: "Boards"
    model: Entities.Board
    url: "v3/collections"