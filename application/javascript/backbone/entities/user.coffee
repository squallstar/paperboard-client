@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.User = Backbone.AuthModel.extend
    defaults:
      full_name: "User"

    needsWalkthrough: ->
      return true