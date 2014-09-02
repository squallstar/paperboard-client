@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.UserPot = Backbone.Model.extend
    defaults:
      seen_walkthrough: false

    url: ->
      "v3/user/bucket"

    save: (key, value, callback) ->
      @attributes[key] = value

      Backbone.OAuth.post
        method: "PUT"
        data:
          value: value
        url: "v3/user/bucket/#{key}"
        success: ->
          if callback then callback true
        error: ->
          if callback then callback false

  # --------------------------------------------------------------------------

  Entities.User = Backbone.AuthModel.extend
    defaults:
      full_name: "User"

    initialize: (data) ->
      @pot = new Entities.UserPot (if data.bucket then data.bucket else {})

    needsWalkthrough: ->
      @pot.get('seen_walkthrough') isnt true

    destroy: ->
      $.removeCookie '_probe_tkn'
      delete App.user