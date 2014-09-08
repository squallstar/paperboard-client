@Paperboard.module "Auth.Connect", (Connect, App, Backbone, Marionette, $, _) ->

  Connect.View = Marionette.ItemView.extend
    template: "connect"
    className: "frms"

    events:
      "click .connect-services .twitter" : "connectTwitter"
      "click .connect-services .instagram" : "connectInstagram"
      "click .btn-skip" : "didClickSkip"

    ui:
      services: ".connect-services"

    firstRender: true
    connectedType: ''

    templateHelpers: ->
      accounts: App.user.getAccounts()

    initialize: ->
      App.vent.on "connected:account", (type) =>
        do @didConnectAccount

    didConnectAccount: ->
      App.boards.fetch()
      @ui.services.animate {opacity: 0.55}, 300, =>
        App.user.fetch
          success: =>
            @ui.services.animate {opacity: 1}, 300
            do @render

    connectTwitter: (event) ->
      do event.preventDefault
      @connectedType = 'twitter'
      path = encodeURIComponent window.location.origin + '/callbacks/connected_account/twitter'
      window.open Backbone.OAuth.url("/v1/source_management/add_twitter_account?d=#{path}"), "connectTwitter", "width=800,height=600"

    connectInstagram: (event) ->
      do event.preventDefault
      @connectedType = 'instagram'
      path = encodeURIComponent window.location.origin + '/callbacks/connected_account/instagram'
      window.open Backbone.OAuth.url("/v1/source_management/add_instagram_account?d=#{path}"), "connectInstagram", "width=800,height=600"

    didClickSkip: (event) ->
      do event.preventDefault
      App.user.pot.save 'connected_services', true
      App.navigate App.rootRoute, true
      App.request "show:intro:walkthrough"

    onBeforeDestroy: ->
      App.vent.off "connected:account"

    onRender: ->
      @$el.find(".account.type-#{@connectedType}").addClass 'flipInX animated'

    onDomRefresh: ->
      if @firstRender
        @firstRender = false
        App.goTop 150