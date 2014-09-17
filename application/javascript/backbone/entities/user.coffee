@Paperboard.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  Entities.UserPot = Backbone.Model.extend
    defaults:
      seen_walkthrough: false
      connected_services: false
      content_discovered: false
      suggestions: []

    url: ->
      'v3/user/bucket'

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

    url: 'v3/user'

    initialize: (data) ->
      @pot = new Entities.UserPot (if data.bucket then data.bucket else {})

    needsWalkthrough: ->
      @pot.get('seen_walkthrough') isnt true

    needsToConnectServices: ->
      @pot.get('connected_services') isnt true

    needsToDiscoverContent: ->
      @pot.get('content_discovered') isnt true

    getAccounts: ->
      accounts =
        twitter: []
        instagram: []
        feedly: []

      for acc in @get 'connected_accounts'
        if acc.type == 'twitter' then accounts.twitter.push acc
        else if acc.type == 'instagram' then accounts.instagram.push acc
        else if acc.type == 'feedly' then accounts.feedly.push acc

      accounts

    getFirstName: ->
      @get('full_name').split(' ')[0]

    destroy: ->
      $.removeCookie '_probe_tkn'
      delete App.user